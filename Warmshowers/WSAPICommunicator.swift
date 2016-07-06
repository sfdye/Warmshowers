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
    case online
    case mocking
}

/**
 A central point of control for all api requests.
 */
class WSAPICommunicator {
    
    // MARK: Properties
    
    static let sharedAPICommunicator = WSAPICommunicator()
    
    let MapSearchLimit: Int = 500
    let KeywordSearchLimit: Int = 50
    
    let session = WSURLSession.sharedSession
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    
    var requests = Set<WSAPIRequest>()
    var mode: WSAPICommunicatorMode
    
    
    // MARK: Initialisers
    
    init() {
        #if TEST
            mode = .Mocking
            print("Initialising as MOCK")
        #else
            mode = .online
            print("Initialising as ONLINE")
        #endif
    }
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    // MARK: Utilities
    
    func contactEndPoint(_ endPoint: WSAPIEndPoint, withParameters params: [String: String]? = nil, thenNotify requester: WSAPIResponseDelegate) {
        let request = WSAPIRequest(endPoint: endPoint, withDelegate: self, andRequester:requester, andParameters: params)
        addRequestToQueue(request)
        executeRequest(request)
    }
    
    func downloadImageAtURL(_ imageURL: String, thenNotify requester: WSAPIResponseDelegate) {
        let request = WSAPIRequest(imageURL: imageURL, withDelegate: self, andRequester:requester)
        addRequestToQueue(request)
        executeRequest(request)
    }
    
    func executeRequest(_ request: WSAPIRequest) {
        
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
            let urlRequest = try NSMutableURLRequest.mutableURLRequestForEndpoint(request.endPoint, withPostParameters: request.params)
            #if TEST
//                print("MOCKING REQUEST")
//                let (data, response, error) = request.endPoint.generateMockResponseForURLRequest(urlRequest)
//                request.delegate.request(request, didRecieveHTTPResponse: data, response: response, andError: error)
            #else
                print("MAKING REQUEST ONLINE")
                let task = session.dataTask(with: urlRequest) { (data, response, error) in         
                    request.delegate.request(request, didRecieveHTTPResponse: data, response: response, andError: error)
                }
                task.resume()
            #endif
            request.status = .sent
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    @objc func reachabilityDidChange() {
        if connection.isOnline {
            flushQueue()
        }
    }
    
    func addRequestToQueue(_ request: WSAPIRequest) {
        request.status = .queued
        requests.insert(request)
    }
    
    func removeRequestFromQueue(_ request: WSAPIRequest) {
        requests.remove(request)
    }
    
    func flushQueue() {
        for request in requests {
            if request.status == .queued {
                executeRequest(request)
            }
        }
    }
    
    // MARK: Network activity indicator control
    // TODO
    
}
