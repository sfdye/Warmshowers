//
//  DataSourceError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 2/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

public enum DataSourceError: Error {
    
    // A data source should send this error to its delegate when it is unable to perform a task due to the application session being in an invalid state.
    // The most common case will be when the session returns a nil account number.
    case invalidSessionState
    
    // A data source should send this error to its delegate when invalid data is received from the API.
    case invalidDataReceived
    
    // A data source should send this error to its delegate when it can not persist data or send data to the API when instructed to save its data.
    case invalidDataToSave
}
