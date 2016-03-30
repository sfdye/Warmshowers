//
//  WSMapControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSMapControllerDelegate {
    func willBeginUpdates()
    func didFinishUpdates()
}