//
//  WSRequests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

//protocol WSRequestAlert {
//    func requestAlert(title: String, message: String)
//}

enum WSRequestError : ErrorType {
    case NoSessionCookie
    case NoCSRFToken
    case JSONSerialisationFailure
}

struct WSRequest {
    
    static let MapSearchLimit: Int = 1000
    
    // MARK: - HTTP Request utilities
    
    // Creates a request for a warmshowers restful service
    //
    static func requestWithService(service: WSRestfulService, params: [String: String]? = nil, token: String? = nil) throws -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest.withWSRestfulService(service)
        
        // Add the session cookie to the header.
        if (service.type != .Login && service.type != .Token) {
//            do {
//                let sessionCookie = try WSSessionData.getSessionCookie()
//                request.addValue(sessionCookie, forHTTPHeaderField: "Cookie")
//            } catch {
//                throw WSRequestError.NoSessionCookie
//            }
        }
        
        // Add the CSRF token to the header.
        // Note: Your not meant to need a CSRF token for login, but if you dont get one sometimes login authentication fails ...
        if (service.method != .Get) {
            if token != nil {
                request.addValue(token!, forHTTPHeaderField: "X-CSRF-Token")
            } else {
                throw WSRequestError.NoCSRFToken
            }
        }

        // Add the request parameters to the request body
        if params != nil {
            request.setBodyContent(params!)
        }
        
        return request
    }
    
    
    // MARK: HTTP Requests
    
    // Makes a normal get request
    //
    static func makeRequestWithService(service: WSRestfulService, doWithResponse: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        do {
            let request = try requestWithService(service)
            let task = WSURLSession.sharedSession.dataTaskWithRequest(request, completionHandler: doWithResponse)
            task.resume()
        } catch {
            print("Failed to build http request")
        }
    }
    
    // Retrieves an image
    //
    static func getImageWithURL(url: String, doWithImage: (image: UIImage?) -> Void ) {
        
        if let url = NSURL(string: url) {
            
            let request = NSMutableURLRequest.init()
            request.URL = url
            request.HTTPMethod = "GET"
            
            let task = WSURLSession.sharedSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                
                if data != nil {
                    let image = UIImage(data: data!)
                    doWithImage(image: image)
                } else {
                    print("Image request failed for url \(request.URL)")
                }
            })
            task.resume()
        }
    }
    
    // To get a users info with their uid
    //
    static func getUserInfo(uid: Int, doWithUserInfo: (info: AnyObject?) -> Void) {
        
        let service = WSRestfulService(type: .UserInfo, uid: uid)!
        
        makeRequestWithService(service) { (data, response, error) -> Void in
            
            print(error)
            print(data)
            
            if error != nil {
                print("Error getting user info")
                print("\(error?.localizedDescription)")
                return
            }
            
            if data != nil {
                let userObject = self.jsonDataToJSONObject(data)
                doWithUserInfo(info: userObject)
            }
        }
    }
    
    // To get the thumbnail size profile image of a user with their uid
    //
    static func getUserThumbnailImage(uid: Int, doWithImage: (image: UIImage?) -> Void) {
        
        getUserInfo(uid) { (info) -> Void in
            if info != nil {
                if let url = info?.valueForKey("profile_image_map_infoWindow") as? String {
                    self.getImageWithURL(url, doWithImage: { (image) -> Void in
                        doWithImage(image: image)
                    })
                }
            } else {
                print("Failed to get user object for thumbnail image request")
            }
        }
    }
    
    // To get feedback on a user
    //
    static func getUserFeedback(uid: Int, doWithUserFeedback: (feedback: AnyObject?) -> Void) {
        
        let service = WSRestfulService(type: .UserFeedback, uid: uid)!
        
        makeRequestWithService(service) { (data, response, error) -> Void in
            if error != nil {
                print("Error getting user feedback")
                print("\(error?.localizedDescription)")
                return
            }
            
            if data != nil {
                let userFeedback = self.jsonDataToJSONObject(data)
                doWithUserFeedback(feedback: userFeedback)
            }
        }
    }

    
    // MARK: - Utilities
    
    // Convert NSData to a json dictionary
    //
    static func jsonDataToJSONObject(data: NSData?) -> AnyObject? {
        
        guard let data = data else {
            return nil
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json
        } catch {
            print("Failed converting JSON data.")
        }
        return nil
    }
    
}
    

