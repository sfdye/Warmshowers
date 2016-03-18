//
//  CCHMapClusterController+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CCHMapClusterController

extension CCHMapClusterController {
    
    func removeAnnotationsWithTileID(tileID: String) {
        
        let hostsOnTile = self.annotations.filter { (user) -> Bool in
            return user.valueForKey("tileID")!.isEqualToString(tileID)
        }
        
        print("\(hostsOnTile) hosts found on the tile")
    }
}
