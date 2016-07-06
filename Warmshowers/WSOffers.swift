//
//  WSOffers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

struct WSOffers {
    
    var allValues = [Bool](repeating: false, count: 8)
    var stringValues: [String] = [
        "Bed",
        "Food",
        "Laundry",
        "Tent Space (for camping)",
        "SAG (vehicle support)",
        "Shower",
        "Storage",
        "Use of Kitchen"
    ]
    var bed: Bool {
        get { return allValues[0] }
        set(newValue) { allValues[0] = newValue }
    }
    var food: Bool {
        get { return allValues[1] }
        set(newValue) { allValues[1] = newValue }
    }
    var laundry: Bool {
        get { return allValues[2] }
        set(newValue) { allValues[2] = newValue }
    }
    var lawnspace: Bool {
        get { return allValues[3] }
        set(newValue) { allValues[3] = newValue }
    }
    var sag: Bool {
        get { return allValues[4] }
        set(newValue) { allValues[4] = newValue }
    }
    var shower: Bool {
        get { return allValues[5] }
        set(newValue) { allValues[5] = newValue }
    }
    var storage: Bool {
        get { return allValues[6] }
        set(newValue) { allValues[6] = newValue }
    }
    var kitchenuse: Bool {
        get { return allValues[7] }
        set(newValue) { allValues[7] = newValue }
    }
    var count: Int {
        
        var count = 0
        
        if bed { count += 1 }
        if food { count += 1 }
        if laundry { count += 1 }
        if lawnspace { count += 1 }
        if sag { count += 1 }
        if shower { count += 1 }
        if storage { count += 1 }
        if kitchenuse { count += 1 }
        
        return count
    }
    
    mutating func update(_ userData: AnyObject?) {
        
        guard let userData = userData else {
            return
        }

        guard let bed = userData.value(forKey: "bed")?.boolValue,
              let food = userData.value(forKey: "food")?.boolValue,
              let laundry = userData.value(forKey: "laundry")?.boolValue,
              let lawnspace = userData.value(forKey: "lawnspace")?.boolValue,
              let sag = userData.value(forKey: "sag")?.boolValue,
              let shower = userData.value(forKey: "shower")?.boolValue,
              let storage = userData.value(forKey: "storage")?.boolValue,
              let kitchenuse = userData.value(forKey: "kitchenuse")?.boolValue
            else {
                return
        }

        self.bed = bed
        self.food = food
        self.laundry = laundry
        self.lawnspace = lawnspace
        self.sag = sag
        self.shower = shower
        self.storage = storage
        self.kitchenuse = kitchenuse
    }
    
    // Returns the nth true offer (offers are kept in alphabetical order)
    //
    func offerAtIndex(_ index: Int) -> String? {
        
        guard let indexes = offerIndexes() where index < indexes.count else {
            return nil
        }
        
        return stringValues[indexes[index]]
    }
    
    // Returns the indexes of the true offers in an array
    // Returns nil if there are no true offers
    func offerIndexes() -> [Int]? {
        
        guard self.count > 0 else{
            return nil
        }
        
        var indexes = [Int]()
        
        for (i, value) in allValues.enumerated() {
            if value {
                indexes.append(i)
            }
        }

        return indexes
    }

}
