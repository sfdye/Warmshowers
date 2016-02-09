//
//  WSRequester.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/*
Requester error codes:
100 - Request aborted
101 - NSURLRequest could not be created
102 - No HTTP response
103 - HTTP bad response
104 - No data recieved
 */

enum WSRequesterError : ErrorType {
    case CouldNotCreateRequest
}

class WSRequester : NSObject {
    
    // URL session
    let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    // Delegate
    var requestDelegate: WSRequestDelegate!
    
    // Request task and response variables
    var task: NSURLSessionDataTask?
    var data: NSData?
    var response: NSURLResponse?
    var httpResponse: NSHTTPURLResponse? { return response as? NSHTTPURLResponse }
    var error: NSError?
    
    // Login manager for getting a new session cookie if required
    lazy var finalAttempt = false
    lazy var loginManager = WSLoginManager()
    
    // Completion handlers
    var success: (() -> Void)?
    var failure: ((error: NSError) -> Void)?
    
    override init() {
        super.init()
    }
    
    // Override this function to perform checks before starting update operations
    //
    func shouldStart() -> Bool {
        return true
    }
    
    // Starts the download and parsing process
    //
    func start() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        guard shouldStart() == true else {
            setError(100, description: "Request aborted")
            end()
            return
        }
        
        var request: NSURLRequest
        do {
            request = try requestDelegate.requestForDownload()
        } catch let error as NSError {
            self.error = error
            end()
            return
        }
        
        print(request)
        
        task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            self.data = data
            self.response = response
            self.error = error
            self.processResponse()
        })
        task?.resume()
    }
    
    // Looks at a data request response and evaluates whether to parse the data or retry the request
    //
    func processResponse() {

        guard error == nil else {
            end()
            return
        }
        
        guard let httpResponse = httpResponse else {
            setError(102, description: "Unauthorised")
            end()
            return
        }

        switch httpResponse.statusCode {
        case 200:
            // Response is ok, proceed to parse the data if there is any
            if data != nil {
                requestDelegate.doWithData(self.data!)
                end()
            } else {
                nilDataAction()
                end()
            }
        default:
            // HTTP bad reesponse
            if shouldRetryRequest() {
                retryReqeust()
            } else {
                setError(103, description: "HTTP request failed with status code \(httpResponse.statusCode)")
                end()
            }
        }
    }
    
    // Converts data to json as AnyObject
    // Returns nil and sets an error if serialisaztion fails
    //
    func dataAsJSON() -> AnyObject? {
        
        guard let data = data else {
            return nil
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json
        } catch let error {
            self.error = error as NSError
            return nil
        }
    }
    
    // Decides if a request should be retried. Override this in subclasses
    //
    func shouldRetryRequest() -> Bool {
        return false
    }
    
    // Retries a request after logging in again. Override this if required in subclasses
    //
    func retryReqeust() {
        end()
    }
    
    // Runs when a request recieved a valid response but with nil data
    //
    func nilDataAction() {
        setError(104, description: "HTTP request recieved a successful response but with no data")
    }
    
    // Decides whether the completion handlers should be called
    //
    func shouldCallCompletionHandler() -> Bool {
        return true
    }
    
    func setError(code: Int, description: String) {
        if error == nil {
            error = NSError(domain: WSErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(description, comment: "")])
        }
    }
    
    // Resets the upater variables
    func reset() {
        finalAttempt = false
        error = nil
    }
    
    // Runs at the end of a request and calls eith success or failure callbacks
    //
    func end() {
        
        if shouldCallCompletionHandler() {
            if error != nil {
                failure?(error: error!)
            } else {
                success?()
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        reset()
    }
    
    // Cancels downloads and data parsing
    //
    func cancel() {
        task?.cancel()
        end()
    }
}
