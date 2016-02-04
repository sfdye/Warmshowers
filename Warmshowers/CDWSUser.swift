//
//  CDWSUser.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

enum CDWSMessageParticipantError : ErrorType {
    case FailedValueForKey(key: String)
}

class CDWSUser: NSManagedObject, WSLazyImage {
    
    // MARK: WSLazyImage Protocol
    
    var lazyImageURL: String? {
        get {
            return image_url
        }
    }
    
    var lazyImage: UIImage? {
        get {
            return image as? UIImage
        }
        set(newImage) {
            image = newImage
        }
    }

}
