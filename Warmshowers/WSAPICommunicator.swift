//
//  WSAPICommunicator.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import ReachabilitySwift

enum WSAPICommunicatorMode {
    case Online
    case Mocking
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
        mode = .Online
    }
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    
    // MARK: Utilities
    
    private func log(message: String) {
        if logging { print(message) }
    }
    
    /** Creates and executes a request for the given end point with the given data. */
    func contactEndPoint(endPoint: WSAPIEndPoint, withPathParameters parameters: AnyObject? = nil, andData data: AnyObject? = nil, thenNotify requester: WSAPIResponseDelegate) {
        
        var request = WSAPIRequest(endPoint: endPoint.instance, withDelegate: self, requester: requester, data: data, andParameters: parameters)
        
        addRequestToQueue(request)
        executeRequest(&request)
    }
    
    // MARK: Request handling
    
    /** Adds authroization headers to a request. */
    private func authorizeURLRequest(inout urlRequest: NSMutableURLRequest) throws {
        let (sessionCookie, token, _) = WSSessionState.sharedSessionState.getSessionData()
        
        // Add the session cookie to the header.
        guard sessionCookie != nil else { throw WSAPICommunicatorError.NoSessionCookie }
        urlRequest.addValue(sessionCookie!, forHTTPHeaderField: "Cookie")
        
        // Add the CSRF token to the header.
        guard token != nil else { throw WSAPICommunicatorError.NoToken }
        urlRequest.addValue(token!, forHTTPHeaderField: "X-CSRF-Token")
    }
    
    /** Executes an API request. */
    private func executeRequest(inout request: WSAPIRequest) {
        
        guard connection.isOnline else {
            // Only keep requests to be processed online later when explicitly specified
            if !requestShouldBeQueuedWhileOffline(request) {
                removeRequestFromQueue(request)
            }
            connection.registerForAndStartNotifications(self, selector: #selector(reachabilityDidChange))
            request.requester?.request(request, didFailWithError: WSAPICommunicatorError.Offline)
            return
        }
        
        do {
            // Generate the request and add any parameters if required.
            var urlRequest = try request.urlRequest()
            
            // Authorize the request if required.
            if request.endPoint.requiresAuthorization {
                try authorizeURLRequest(&urlRequest)
            }
            
            // Dispatch the request.
            switch mode {
            case .Online:
                let task = urlSession.dataTaskWithRequest(urlRequest) { [weak self] (data, response, error) in
                    self?.didRecieveHTTPResponseWithData(data, response: response, andError: error, forRequest: &request)
                }
                task.resume()
            case .Mocking:
                assertionFailure("Mocking behaviour not yet defined.")
            }
            request.status = .Sent
            
            log("Request dispatched to: \(urlRequest.URL)")
            
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    /** Handles network responses and delegates control of the request. */
    private func didRecieveHTTPResponseWithData(data: NSData?, response: NSURLResponse?, andError error: NSError?, inout forRequest request: WSAPIRequest) {
        
        request.status = .RecievedResponse
        
        // Handle HTTP errors
        guard error == nil else {
            request.delegate.request(request, didFailWithError: error!)
            return
        }
        
        let statusCode = (response as! NSHTTPURLResponse).statusCode
        
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
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    if let jsonArray = json as? NSArray {
                        if let message = jsonArray.objectAtIndex(0) as? String {
                            body = message
                        }
                    }
                } catch {
                    request.delegate.request(request, didFailWithError: error)
                }
            }
            
            error = .ServerError(statusCode: statusCode, body: body)
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        guard let data = data where request.endPoint.doesExpectDataWithResponse() == true else {
            let error = WSAPICommunicatorError.NoData
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        // Begin parsing data
        request.status = .Parsing
        
        do {
            var parsedData: AnyObject? = nil
            switch request.endPoint.acceptType {
            case .PlainText:
                if let text = String.init(data: data, encoding: NSUTF8StringEncoding) {
                    log("Recieved text response: \(text)")
                    parsedData = try request.endPoint.request(request, didRecieveResponseWithText: text)
                    request.delegate.request(request, didSucceedWithData: parsedData)
                } else {
                    request.delegate.request(request, didFailWithError: WSAPIEndPointError.ParsingError(endPoint: request.endPoint.name, key: nil))
                }
            case .JSON:
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments])
                log("Recieved JSON response: \(json)")
                parsedData = try request.endPoint.request(request, didRecieveResponseWithJSON: json)
                try request.endPoint.request(request, updateStore: store, withJSON: json)
                request.delegate.request(request, didSucceedWithData: parsedData)
            case .Image:
                if let image = UIImage(data: data) {
                    request.delegate.request(request, didSucceedWithData: image)
                } else {
                    request.delegate.request(request, didFailWithError: WSAPIEndPointError.ParsingError(endPoint: request.endPoint.name, key: nil))
                }
            }
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    
    // MARK: Queuing
    
    /** Adds a request to the request queue. */
    func addRequestToQueue(request: WSAPIRequest) {
        request.status = .Queued
        requests.insert(request)
    }
    
    /** Removes a request to the request queue. */
    func removeRequestFromQueue(request: WSAPIRequest) {
        requests.remove(request)
    }
    
    /** Executes all queued request. */
    private func flushQueue() {
        for var request in requests {
            if request.status == .Queued {
                executeRequest(&request)
            }
        }
    }
    
    
    // MARK: Reachability
    
    /** This method is called when the reachability status is changed */
    @objc private func reachabilityDidChange() {
        if connection.isOnline {
            flushQueue()
        }
    }
    
    
    // MARK: Network activity indicator control
    // TODO
    
}