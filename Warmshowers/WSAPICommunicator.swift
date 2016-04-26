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

enum WSAPICommunicatorError : ErrorType {
    case Offline
    case NoSessionCookie
    case NoToken
    case ServerError(statusCode: Int)
    case NoData
}

/**
 A central point of control for all api requests.
 */
class WSAPICommunicator : WSAPICommunicatorProtocol {
    
    // MARK: Properties
    
    static let sharedAPICommunicator = WSAPICommunicator()
    
    let session = WSURLSession.sharedSession
    
    var mode: WSAPICommunicatorMode
    
    var requests = Set<WSAPIRequest>()
    var queue = NSOperationQueue()
    
    var reachability: Reachability
    var offline: Bool { return !reachability.isReachable() }
    
    
    // MARK: Initialisers
    
    init() {
        #if TEST
            mode = .Mocking
            print("Initialising as MOCK")
        #else
            mode = .Online
            print("Initialising as ONLINE")
        #endif
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch  {
            preconditionFailure("Reachability failed to initialise")
        }
    }
    
    // MARK: Utilities
    
    func contactEndPoint(endPoint: WSAPIEndPoint, withParameters params: [String: String]? = nil, thenNotify requester: WSAPIResponseDelegate) {
        
        // If offline notify the requester
        guard !offline  else {
            requester.didRecieveAPIFailureResponse(WSAPICommunicatorError.Offline)
            return
        }
    
        // Else add a request to the queue
        let request = WSAPIRequest(endPoint: .CreateFeedback, withDelegate: self, andRequester:requester)
        addRequestToQueue(request)
        
        do {
            let urlRequest = try NSMutableURLRequest.mutableURLRequestForEndpoint(request.endPoint, withPostParameters: params)
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
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    func addRequestToQueue(request: WSAPIRequest) {
        requests.insert(request)
    }
    
    func removeRequestFromQueue(request: WSAPIRequest) {
        requests.remove(request)
    }
    
    // MARK: Network activity indicator control
    // TODO

    
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