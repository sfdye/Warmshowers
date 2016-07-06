//
//  CDWSMessage.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

enum CDWSMessageError : ErrorProtocol {
    case failedValueForKey(key: String)
}

class CDWSMessage: NSManagedObject {
    
    var authorName: String? {
        if let author = self.author {
            return author.fullname
        } else {
            return nil
        }
    }
    
    var authorThumbnail: UIImage? {
        if let author = self.author {
            return author.image as? UIImage
        } else {
            return nil
        }
    }

}
