//
//  WSRequestDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSRequestDelegate {
    func requestForDownload() -> NSURLRequest?
    func doWithData(data: NSData)
}
