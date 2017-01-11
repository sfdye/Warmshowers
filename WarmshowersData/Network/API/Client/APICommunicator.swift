//
//  APICommunicator.swift
//  Powershop
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/** A central point of control for all API requests. */
class APICommunicator: NSObject, APIDelegate {
    
    // MARK: Properties
    
    var mode: APICommunicatorMode = .online
    
    var requests = Set<APIRequest>()
    private let jsonParser: JSONParser = JSON.shared
    
    // Congfuguration and Delegates
    
    lazy var connection: ReachabilityDelegate = {
        let connection = ReachabilityManager()
        return connection
    }()
    
    lazy var cache: URLCache = {
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheURL = cachesDirectoryURL.appendingPathComponent("WarmshowersCache")
        let diskPath = cacheURL.path
        let cache = URLCache(memoryCapacity: 5 * 1048576, diskCapacity: 50 * 1048576, diskPath: diskPath)
        return cache
    }()
    
    lazy var sessionConfiguration: URLSessionConfiguration = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.urlCache = self.cache
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        return sessionConfiguration
    }()
    
    lazy var session: URLSession = {
        let session = URLSession(configuration: self.sessionConfiguration)
        return session
    }()
    
    lazy var auth: (APIAuthorizationDelegate & APILoginDelegate)! = {
        let auth = APIAuthorizer(delegate: self)
        return auth
    }()
    
    lazy var secureStore: SecureStoreDelegate? = {
        return DataDelegates.shared.secureStore
    }()
    
    lazy var store: StoreUpdateDelegate? = {
        return DataDelegates.shared.store as? StoreUpdateDelegate
    }()
    
    var delegate: APICommunicatorDelegate?
    
    // MARK: Initialisers
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    // MARK: Debug utilities
    
    #if DEBUG
    var logging: Bool = true
    #else
    var logging: Bool = false
    #endif
    
    func log(_ message: String, logQueueState: Bool = false) {
        if logging { print(message) }
        if logging && logQueueState { self.logQueueState() }
    }
    
    private func logQueueState() {
        let created = requests.filter { (request) -> Bool in request.status == .created }
        let queued = requests.filter { (request) -> Bool in request.status == .queued }
        let sent = requests.filter { (request) -> Bool in request.status == .sent }
        let responseReceived = requests.filter { (request) -> Bool in request.status == .recievedResponse }
        let parsing = requests.filter { (request) -> Bool in request.status == .parsing }
        log("Created: \(created.count), Queued: \(queued.count), Sent: \(sent.count), Response received: \(responseReceived.count), Parsing: \(parsing.count)\n")
    }
    
    // MARK: Utilities
    
    func error(fromData data: Data?) -> String? {
        var body: String? = nil
        
        if
            let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonArray = json as? [Any],
            let message = jsonArray.first as? String
        {
            body = message
        }
        
        return body
    }
    
    // MARK: API Delegate
    
    var login: APILoginDelegate {
        return auth
    }
    
    func set(delegate: APICommunicatorDelegate) {
        self.delegate = delegate
    }
    
    /** Creates and executes a request for the given end point with the given data. */
    func contact(endPoint: APIEndPoint, withMethod method: HTTP.Method, andPathParameters parameters: Any?, andData data: Any?, thenNotify requester: APIResponseDelegate, ignoreCache: Bool = false) {
        
        let request = APIRequest(withEndPoint: endPoint.instance, httpMethod: method, requester: requester, parameters: parameters, andData: data)
        request.delegate = self
        
        // Ensure a delegate is set before proceeding.
        guard delegate != nil else {
            assertionFailure("API Communicator has no delegate.")
            request.delegate?.request(request, didFailWithError: APICommunicatorError.noDelegate)
            return
        }
        
        log("Queuing request: \(request.hashValue). (\(request.endPointType.rawValue) end point.)", logQueueState: true)
        addRequestToQueue(request)
        executeQueuedRequests()
    }
    
    // MARK: Request handling
    
    /** Executes an API request. */
    private func execute(_ request: APIRequest) {
        
        log("Executing request: \(request.hashValue). (\(request.endPointType.rawValue) end point.)", logQueueState: true)
        
        guard connection.isOnline else {
            // Only keep requests to be processed online later when explicitly specified
            if !(delegate?.requestShouldBeQueuedWhileOffline(request) ?? false) {
                removeRequestFromQueue(request)
            }
            connection.registerForAndStartNotifications(self, selector: #selector(reachabilityDidChange))
            request.requester?.request(request, didFailWithError: APICommunicatorError.offline)
            return
        }
    
        // Generate an authorized request
        let urlRequest: URLRequest
        do {
            assert(secureStore != nil, "Attempted to update persisted data without a secure store delegate. Please ensure the secure store delegate on the API communicator is non-nill.")
            urlRequest = try auth.authorizedURLRequest(fromAPIRequest: request, withSecureStore: secureStore!)
        } catch let error {
            
            if let error = (error as? APIAuthorizerError), error == .currentlyReauthorizing {
                // Leave the request in the queue until reauthorization has finished.
                return
            }
            
            request.delegate?.request(request, didFailWithError: error)
            return
        }
        
        
        // Dispatch the request.
        switch mode {
        case .online:
            (session.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
                self?.didRecieveHTTPResponseWithData(data, response: response, andError: error, forRequest: request)
            })).resume()
        case .demo:
            assertionFailure("Demo bahaviour not yest defined.")
        case .mocking:
            assertionFailure("Mocking behaviour not yet defined.")
        }
        
        request.status = .sent
        
        log("Request dispatched to: \(urlRequest.url)")
        log("Header: \(urlRequest.allHTTPHeaderFields)", logQueueState: true)
    }
    
    /** Handles network responses and delegates control of the request. */
    private func didRecieveHTTPResponseWithData(_ data: Data?, response: URLResponse?, andError error: Error?, forRequest request: APIRequest) {
        
        request.status = .recievedResponse
        log("Received response for request: \(request.hashValue).", logQueueState: true)
        
        // Handle HTTP errors.
        guard error == nil else {
            request.delegate?.request(request, didFailWithError: error!)
            return
        }
        
        // Handle error responses
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard request.endPoint.successCodes.contains(statusCode) else {
            
            // 403: Access denied for user anonymous.
            // The user is unauthorized or the sesison has expired so the user must log in again.
            if statusCode == 403 {
                
                // Try to re-authorize the user with their username and password.
                do {
                    let (username, password) = try secureStore!.getUsernameAndPassword()
                    
                    log("Auto-login triggered.")
                    auth.login(withUsername: username, andPassword: password, thenNotify: self)
                    
                    // Re-queue the request.
                    request.status = .queued
                    
                    
                    return
                } catch {
                    assertionFailure("Revoke access behaviour needs fixing.")
                    // session.didLogout(fromViewContoller: nil)
                }
            }

            let body = self.error(fromData: data)
            let error = APICommunicatorError.serverError(statusCode: statusCode, body: body)
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        // Handle nil data responses
        guard let data = data, request.endPoint.doesExpectDataInResponseForRequest(request) == true else {
            let error = APICommunicatorError.noData
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        // Begin parsing data.
        
        request.status = .parsing
        log("Parsing response for request: \(request.hashValue).", logQueueState: true)
        
        do {
            var parsedData: Any? = nil
            switch request.endPoint.acceptType {
            case .plainText:
                if let text = String.init(data: data, encoding: String.Encoding.utf8) {
                    //log("Recieved text response: \(text)")
                    parsedData = try request.endPoint.request(request, didRecieveResponseWithText: text)
                } else {
                    request.delegate.request(request, didFailWithError: APIEndPointError.parsingError(endPoint: request.endPoint.name, key: nil))
                    return
                }
            case .json:
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                //log("Recieved JSON response: \(json)")
                
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
        request.status = .queued
        requests.insert(request)
    }
    
    /** Removes a request to the request queue. */
    func removeRequestFromQueue(_ request: APIRequest) {
        requests.remove(request)
    }
    
    /** Executes all queued request. */
    func executeQueuedRequests() {
        
        for request in requests {
            if request.status == .queued {
                execute(request)
            }
        }
    }
    
    // MARK: Reachability
    
    /** This method is called when the reachability status is changed */
    @objc fileprivate func reachabilityDidChange() {
        if connection.isOnline {
            executeQueuedRequests()
        }
    }
    
    // MARK: Network activity indicator control
    // TODO
    
}
