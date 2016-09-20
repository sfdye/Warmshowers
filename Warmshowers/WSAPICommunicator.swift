//
//  WSAPICommunicator.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

enum WSAPICommunicatorMode {
    case online
    case mocking
}

/**
 A central point of control for all api requests.
 */
class WSAPICommunicator: WSAPICommunicatorProtocol {
    
    static let sharedAPICommunicator = WSAPICommunicator()
    
    var urlSession = WSURLSession.sharedSession
    var host = WSAPIHost.sharedAPIHost
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    var store: WSStoreProtocol = WSStore.sharedStore
    var session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    
    var mode: WSAPICommunicatorMode
    var logging: Bool = false
    
    var requests = Set<WSAPIRequest>()
    
    
    // MARK: Initialisers
    
    init() {
        mode = .online
    }
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    
    // MARK: Utilities
    
    fileprivate func log(_ message: String) {
        if logging { print(message) }
    }
    
    /** Creates and executes a request for the given end point with the given data. */
    func contactEndPoint(_ endPoint: WSAPIEndPoint, withPathParameters parameters: Any? = nil, andData data: Any? = nil, thenNotify requester: WSAPIResponseDelegate) {
        
        let request = WSAPIRequest(endPoint: endPoint.instance, withDelegate: self, requester: requester, data: data, andParameters: parameters)
        
        addRequestToQueue(request)
        execute(request: request)
    }
    
    // MARK: Request handling
    
    /** Adds authroization headers to a request. */
    fileprivate func authorize(urlRequest: inout URLRequest) throws {
        let (sessionCookie, token, _) = WSSessionState.sharedSessionState.getSessionData()
        
        // Add the session cookie to the header.
        guard sessionCookie != nil else { throw WSAPICommunicatorError.noSessionCookie }
        urlRequest.addValue(sessionCookie!, forHTTPHeaderField: "Cookie")
        
        // Add the CSRF token to the header.
        guard token != nil else { throw WSAPICommunicatorError.noToken }
        urlRequest.addValue(token!, forHTTPHeaderField: "X-CSRF-Token")
    }
    
    /** Executes an API request. */
    fileprivate func execute(request: WSAPIRequest) {
        
        guard connection.isOnline else {
            // Only keep requests to be processed online later when explicitly specified
            if !requestShouldBeQueuedWhileOffline(request) {
                removeRequestFromQueue(request)
            }
            connection.registerForAndStartNotifications(self, selector: #selector(reachabilityDidChange))
            request.requester?.request(request, didFailWithError: WSAPICommunicatorError.offline)
            return
        }
        
        do {
            // Generate the request and add any parameters if required.
            var urlRequest = try request.urlRequest()
            
            // Authorize the request if required.
            if request.endPoint.requiresAuthorization {
                try authorize(urlRequest: &urlRequest)
            }
            
            // Dispatch the request.
            switch mode {
            case .online:
                let task = urlSession.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
//                    self.didRecieveHTTPResponseWithData(data, response: response, andError: error, forRequest: request)
                    self?.didRecieveHTTPResponse(withData: nil, response: nil, andError: nil, forRequest: request)
                })
                task.resume()
            case .mocking:
                assertionFailure("Mocking behaviour not yet defined.")
            }
//            request.status = .sent
            
            log("Request dispatched to: \(urlRequest.url)")
            
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    /** Handles network responses and delegates control of the request. */
    fileprivate func didRecieveHTTPResponse(withData data: Data?, response: URLResponse?, andError error: NSError?, forRequest request: WSAPIRequest) {
        
//        request.status = .recievedResponse
        
        // Handle HTTP errors
        guard error == nil else {
            request.delegate.request(request, didFailWithError: error!)
            return
        }
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        
        // Handle error responses
        guard request.endPoint.successCodes.contains(statusCode) else {
            
            // The user is unauthorized and must log in again.
            if statusCode == 403 {
                session.didLogoutFromView(nil)
            }
            
            var error: WSAPICommunicatorError
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
        
        guard let data = data , request.endPoint.doesExpectDataWithResponse() == true else {
            let error = WSAPICommunicatorError.noData
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        // Begin parsing data
//        request.status = .parsing
        
        do {
            var parsedData: Any? = nil
            switch request.endPoint.acceptType {
            case .PlainText:
                if let text = String.init(data: data, encoding: String.Encoding.utf8) {
                    log("Recieved text response: \(text)")
                    parsedData = try request.endPoint.request(request, didRecieveResponseWithText: text)
                    request.delegate.request(request, didSucceedWithData: parsedData)
                } else {
                    request.delegate.request(request, didFailWithError: WSAPIEndPointError.parsingError(endPoint: request.endPoint.name, key: nil))
                }
            case .JSON:
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                log("Recieved JSON response: \(json)")
                parsedData = try request.endPoint.request(request, didRecieveResponseWithJSON: json)
                try request.endPoint.request(request, updateStore: store, withJSON: json)
                request.delegate.request(request, didSucceedWithData: parsedData)
            case .Image:
                if let image = UIImage(data: data) {
                    request.delegate.request(request, didSucceedWithData: image)
                } else {
                    request.delegate.request(request, didFailWithError: WSAPIEndPointError.parsingError(endPoint: request.endPoint.name, key: nil))
                }
            }
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    
    // MARK: Queuing
    
    /** Adds a request to the request queue. */
    func addRequestToQueue(_ request: WSAPIRequest) {
//        request.status = .queued
        requests.insert(request)
    }
    
    /** Removes a request to the request queue. */
    func removeRequestFromQueue(_ request: WSAPIRequest) {
        requests.remove(request)
    }
    
    /** Executes all queued request. */
    fileprivate func flushQueue() {
        for request in requests {
            if request.status == .queued {
                execute(request: request)
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
