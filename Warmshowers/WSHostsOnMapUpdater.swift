//
//  WSHostsOnMapUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

// This class is for downloading hosts from warmshowers for a give map region
//
class WSHostsOnMapUpdater : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var hostsOnMap: [WSUserLocation]!
    var mapView: MKMapView!
    let MapSearchLimit: Int = 800
    
    init(hostsOnMap: [WSUserLocation], mapView: MKMapView) {
        super.init()
        requestDelegate = self
        self.hostsOnMap = hostsOnMap
        self.mapView = mapView
    }
    
    func requestForDownload() -> NSURLRequest? {
        let service = WSRestfulService(type: .searchByLocation)!
        var params = mapView.getWSMapRegion()
        params["limit"] = String(MapSearchLimit)
        let request = WSRequest.requestWithService(service, params: params, token: token)
        return request
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() else {
            return
        }
        
        // Parse the json
        self.hostsOnMap = [WSUserLocation]()
        if let accounts = json["accounts"] as? NSArray {
            for account in accounts {
                if let user = WSUserLocation(json: account) {
                    self.hostsOnMap.append(user)
                }
            }
        }
    }

}