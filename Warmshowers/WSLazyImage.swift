//
//  WSLazyImageObject.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSLazyImage {
    var lazyImageURL: String? { get }
    var lazyImage: UIImage? { get set }
}

enum WSLazyImageError : ErrorType {
    case NoImageURL
    case CouldNotFormURL
}
