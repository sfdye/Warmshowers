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
class WSAPICommunicator : WSAPICommunicatorProtocol {
    
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
            mode = .Online
            print("Initialising as ONLINE")
        #endif
    }
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    // MARK: Utilities
    
    func contactEndPoint(endPoint: WSAPIEndPoint, withParameters params: [String: String]? = nil, thenNotify requester: WSAPIResponseDelegate) {
        let request = WSAPIRequest(endPoint: endPoint, withDelegate: self, andRequester:requester, andParameters: params)
        addRequestToQueue(request)
        executeRequest(request)
    }
    
    func executeRequest(request: WSAPIRequest) {
        
        guard connection.isOnline else {
            // Only keep requests to be processed online later when explicitly specified
            if !requestShouldBeQueuedWhileOffline(request) {
                removeRequestFromQueue(request)
            }
            connection.registerForAndStartNotifications(self, selector: #selector(reachabilityDidChange))
            request.requester?.didRecieveAPIFailureResponse(WSAPICommunicatorError.Offline)
            return
        }
    
        do {
            let urlRequest = try NSMutableURLRequest.mutableURLRequestForEndpoint(request.endPoint, withPostParameters: request.params)
            #if TEST
                print("MOCKING REQUEST")
                let (data, response, error) = request.endPoint.generateMockResponseForURLRequest(urlRequest)
                request.delegate.request(request, didRecieveHTTPResponse: data, response: response, andError: error)
            #else
                print("MAKING REQUEST ONLINE")
                let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) in
                    request.delegate.request(request, didRecieveHTTPResponse: data, response: response, andError: error)
                }
                task.resume()
            #endif
            request.status = .Sent
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    @objc func reachabilityDidChange() {
        if connection.isOnline {
            flushQueue()
        }
    }
    
    func addRequestToQueue(request: WSAPIRequest) {
        request.status = .Queued
        requests.insert(request)
    }
    
    func removeRequestFromQueue(request: WSAPIRequest) {
        requests.remove(request)
    }
    
    func flushQueue() {
        for request in requests {
            if request.status == .Queued {
                executeRequest(request)
            }
        }
    }
    
    // MARK: Network activity indicator control
    // TODO
    
    func getTokenAndNotify(requester: WSAPIResponseDelegate) {
        contactEndPoint(.Token, thenNotify: requester)
    }

    func login(username: String, password: String, andNotify requester: WSAPIResponseDelegate) {
        
        let params = ["username" : username, "password" : password]
        
        contactEndPoint(.Login, withParameters: params, thenNotify: requester)
    }
    
    func logoutAndNotify(requester: WSAPIResponseDelegate) {
        contactEndPoint(.Logout, thenNotify: requester)
    }
    
    func searchByLocation(regionLimits: [String: String], andNotify requester: WSAPIResponseDelegate) {
        
        var params = regionLimits
        params["limit"] = String(MapSearchLimit)
        
        contactEndPoint(.SearchByLocation, withParameters: params, thenNotify: requester)
    }
    
    func searchByKeyword(keyword: String, offset: Int, andNotify requester: WSAPIResponseDelegate) {
        
        var params = [String: String]()
        params["keyword"] = keyword ?? " "
        params["offset"] = String(offset)
        params["limit"] = String(KeywordSearchLimit)
        
        contactEndPoint(.SearchByKeyword, withParameters: params, thenNotify: requester)
    }
    
    func createFeedback(feedback: WSRecommendation, andNotify requester: WSAPIResponseDelegate) {
        
        var params = [String: String]()
        params["node[type]"] = "trust_referral"
        params["node[field_member_i_trust][0][uid][uid]"] = feedback.recommendedUserName
        params["node[field_rating][value]"] = feedback.rating.rawValue
        params["node[body]"] = feedback.body
        params["node[field_guest_or_host][value]"] = feedback.type.rawValue
        params["node[field_hosting_date][0][value][year]"] = String(feedback.year)
        params["node[field_hosting_date][0][value][month]"] = String(feedback.month)
        
        contactEndPoint(.CreateFeedback, withParameters: params, thenNotify: requester)
    }
    
}