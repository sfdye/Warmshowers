//
//  WSRequestDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSRequestDelegate {
    func requestForDownload() throws -> NSURLRequest
    func doWithData(data: NSData)
}
