//
//  APICommunicator.swift
//  Powershop
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/** A central point of control for all API requests. */
public class APICommunicator: APIDelegate {
    
    // MARK: Properties
    
    public var mode: APICommunicatorMode = .online
    public var logging: Bool = false
    
    fileprivate var requests = Set<APIRequest>()
    fileprivate var session = WarmShowersURLSession.shared
    fileprivate let jsonParser: JSONParser = JSON.shared
    
    // Congfuguration and Delegates
    
    public var connection: ReachabilityDelegate = ReachabilityManager()
    public var auth: APIAuthorizationDelegate = APIRequestAuthorizer()
    public var delegate: APICommunicatorDelegate?
    
    var secureStore: SecureStoreDelegate? {
        return DataDelegates.shared.secureStore
    }
    
    var store: StoreUpdateDelegate? {
        return DataDelegates.shared.store as? StoreUpdateDelegate
    }
    
    // MARK: Initialisers
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    // MARK: Utilities
    
    fileprivate func log(_ message: String) {
        if logging { print(message) }
    }
    
    public func set(delegate: APICommunicatorDelegate) {
        self.delegate = delegate
    }
    
    /** Creates and executes a request for the given end point with the given data. */
    public func contact(endPoint: APIEndPoint, withMethod method: HTTP.Method, andPathParameters parameters: Any?, andData data: Any?, thenNotify requester: APIResponseDelegate) {
        
        let request = APIRequest(withEndPoint: endPoint.instance, httpMethod: method, requester: requester, parameters: parameters, andData: data)
        request.delegate = self
        
        // Ensure a delegate is set before proceeding.
        guard delegate != nil else {
            request.delegate?.request(request, didFailWithError: APICommunicatorError.noDelegate)
            return
        }
        
        addRequestToQueue(request)
        executeRequest(request)
    }
    
    
    // MARK: Request handling
    
    /** Executes an API request. */
    fileprivate func executeRequest(_ request: APIRequest) {
        
        guard connection.isOnline else {
            // Only keep requests to be processed online later when explicitly specified
            if !requestShouldBeQueuedWhileOffline(request) {
                removeRequestFromQueue(request)
            }
            connection.registerForAndStartNotifications(self, selector: #selector(reachabilityDidChange))
            request.requester?.request(request, didFailWithError: APICommunicatorError.offline)
            return
        }
    
        do {
            // Generate the request and add any parameters if required.
            assert(secureStore != nil, "Attempted to update persisted data without a secure store delegate. Please ensure the secure store delegate on the API communicator is non-nill.")
            let urlRequest = try auth.authorizedURLRequest(fromAPIRequest: request, withSecureStore: secureStore!)
            
            // Dispatch the request.
            switch mode {
            case .online:
                let task = session.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
                    self?.didRecieveHTTPResponseWithData(data, response: response, andError: error, forRequest: request)
                })
                task.resume()
            case .demo:
                assertionFailure("Demo bahaviour not yest defined.")
            case .mocking:
                assertionFailure("Mocking behaviour not yet defined.")
            }
            
            log("Request dispatched to: \(urlRequest.url)")
            log("Header: \(urlRequest.allHTTPHeaderFields)")
            
        } catch let error {
            request.delegate?.request(request, didFailWithError: error)
        }
    }
    
    /** Handles network responses and delegates control of the request. */
    fileprivate func didRecieveHTTPResponseWithData(_ data: Data?, response: URLResponse?, andError error: Error?, forRequest request: APIRequest) {
        
        // Handle HTTP errors.
        guard error == nil else {
            request.delegate?.request(request, didFailWithError: error!)
            return
        }
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        
        // Handle error responses
        guard request.endPoint.successCodes.contains(statusCode) else {
            
            // The user is unauthorized and must log in again.
            if statusCode == 403 {
                // fix this with authorization handling.
                // session.didLogout(fromViewContoller: nil)
            }
            
            var error: APICommunicatorError
            var body: String = ""
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonArray = json as? NSArray {
                        if let message = jsonArray.object(at: 0) as? String {
                            body = message
                        }
                    }
                } catch {
                    request.delegate.request(request, didFailWithError: error)
                }
            }
            
            error = .serverError(statusCode: statusCode, body: body)
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        guard let data = data, request.endPoint.doesExpectDataInResponseForRequest(request) == true else {
            let error = APICommunicatorError.noData
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        // Begin parsing data.
        do {
            var parsedData: Any? = nil
            switch request.endPoint.acceptType {
            case .plainText:
                if let text = String.init(data: data, encoding: String.Encoding.utf8) {
                    log("Recieved text response: \(text)")
                    parsedData = try request.endPoint.request(request, didRecieveResponseWithText: text)
                } else {
                    request.delegate.request(request, didFailWithError: APIEndPointError.parsingError(endPoint: request.endPoint.name, key: nil))
                    return
                }
            case .json:
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                log("Recieved JSON response: \(json)")
                
                // Let the end point update the store with the recieved JSON. This is used by the Revoke Access end point.
                // This is called before the gaurd condition below since the response from the Revoke Access end point does not contain a data field.
                assert(secureStore != nil, "Attempted to update persisted data without a secure store delegate. Please ensure the secure store delegate on the API communicator is non-nill.")
                try request.endPoint.request(request, updateSecureStore: secureStore!, withJSON: json, parser: jsonParser)
                
                // Most Powershop requests return data in the "data" field of the JSON. End points that do not get a data field in the reponse should specify this in their doesExpectDataInResponseForRequest(_:) method.
                // Abort if this field is not present.
                guard request.endPoint.doesExpectDataInResponseForRequest(request) else { break }
                guard json is [String: Any] || json is [Any] else {
                        assertionFailure("Receieved a successful API response with no valid JSON in the body. If this end point does not return data for HTTP method \(request.method) set end point's doesExpectDataInResponseForRequest(_:) method to return false in this case.")
                        throw APIEndPointError.parsingError(endPoint: request.endPoint.name, key: nil)
                }
                
                // Let the end point update the store with the recieved data field.
                assert(store != nil, "Attempted to update persisted data without a store update delegate. Please ensure the store update delegate on the API communicator is non-nill.")
                try request.endPoint.request(request, updateStore: store!, withJSON: json, parser: jsonParser)
                
                // Let the end point parse any data recieved in the data field.
                // The parsed data is returned to the requester throught the call to didSucceedWithData: below.
                parsedData = try request.endPoint.request(request, didRecieveResponseWithJSON: json, parser: jsonParser)
                
            case .image:
                if let image = UIImage(data: data) {
                    parsedData = image
                } else {
                    request.delegate.request(request, didFailWithError: APIEndPointError.parsingError(endPoint: request.endPoint.name, key: nil))
                    return
                }
            default:
                // x-form-url-encoded
                break
            }
            request.delegate.request(request, didSucceedWithData: parsedData)
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    
    // MARK: Queuing
    
    /** Adds a request to the request queue. */
    func addRequestToQueue(_ request: APIRequest) {
        requests.insert(request)
    }
    
    /** Removes a request to the request queue. */
    func removeRequestFromQueue(_ request: APIRequest) {
        requests.remove(request)
    }
    
    /** Executes all queued request. */
    fileprivate func flushQueue() {
        for request in requests {
            if request.status == .queued {
                executeRequest(request)
            }
        }
    }
    
    
    // MARK: Reachability
    
    /** This method is called when the reachability status is changed */
    @objc fileprivate func reachabilityDidChange() {
        if connection.isOnline {
            flushQueue()
        }
    }
    
    // MARK: Network activity indicator control
    // TODO
    
}
