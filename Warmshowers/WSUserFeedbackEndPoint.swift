//
//  WSUserFeedbackEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSUserFeedbackEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .UserFeedback
    
    var httpMethod: HttpMethod = .Get
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        assertionFailure("path needs uid")
        return hostURL.URLByAppendingPathComponent("/user/<uid>/json_recommendations")
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
//        var feedback = [WSRecommendation]()
//        
//        // Parse the data
//        if let allRecommendations = json.valueForKey("recommendations") as? NSArray {
//            for recommendationObject in allRecommendations {
//                if let recommendationJSON = recommendationObject.valueForKey("recommendation") {
//                    if let recommendation = WSRecommendation(json: recommendationJSON) {
//                        feedback.append(recommendation)
//                    }
//                }
//            }
//        }
//        
//        // Set the feedback and update the table view
//        self.feedback = feedback
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
//        })
//        
//        // Update the feedback with user thumbnail urls
//        for feedback in self.feedback {
//            
//            guard let uid = feedback.author?.uid else {
//                return
//            }
//            
//            WSRequest.getUserInfo(uid, doWithUserInfo: { (info) -> Void in
//                
//                guard let info = info else {
//                    return
//                }
//                
//                if let user = WSUserLocation(json: info) {
//                    feedback.authorImageURL = user.thumbnailImageURL
//                }
//            })
//        }
        
        return nil
    }
}