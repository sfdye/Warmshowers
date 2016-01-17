//
//  WSGetHostsOnMapOperation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSGetHostsOnMapOperation : NSOperation {
    
    var mapView: MKMapView!
    var success: ((hosts: [WSUserLocation]) -> Void)?
    var failure: (() -> Void)?
    
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init()
    }
    
    override func main() {
        
        WSRequest.getHostDataForMapView(mapView) { (data) -> Void in
            
            // About if the operation was cancelled
            guard self.cancelled == false else {
                return
            }
            
            // Update the mapView data source
            if let data = data {
                
                var hosts = [WSUserLocation]()
                
                // parse the json
                if let json = WSRequest.jsonDataToDictionary(data) {
                    if let accounts = json["accounts"] as? NSArray {
                        for account in accounts {
                            if let user = WSUserLocation(json: account) {
                                hosts.append(user)
                            }
                        }
                    }
                }
                
                
                if hosts.count > 0 && self.cancelled == false {
                    self.success?(hosts: hosts)
                }
            }
            self.failure?()
        }
    }
    
}