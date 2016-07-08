//
//  WSHostSearchControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSHostSearchControllerDelegate {
    
    /** Presents an error alert */
    func presentErrorAlertWithError(error: ErrorType)

}