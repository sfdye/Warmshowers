//
//  WSOffers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

struct WSOffers {
    
    var allValues = [Bool](count: 8, repeatedValue: false)
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
        
        if bed { count++ }
        if food { count++ }
        if laundry { count++ }
        if lawnspace { count++ }
        if sag { count++ }
        if shower { count++ }
        if storage { count++ }
        if kitchenuse { count++ }
        
        return count
    }
    
    mutating func update(userData: AnyObject?) {
        
        guard let userData = userData else {
            return
        }

        guard let bed = userData.valueForKey("bed")?.boolValue,
              let food = userData.valueForKey("food")?.boolValue,
              let laundry = userData.valueForKey("laundry")?.boolValue,
              let lawnspace = userData.valueForKey("lawnspace")?.boolValue,
              let sag = userData.valueForKey("sag")?.boolValue,
              let shower = userData.valueForKey("shower")?.boolValue,
              let storage = userData.valueForKey("storage")?.boolValue,
              let kitchenuse = userData.valueForKey("kitchenuse")?.boolValue
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
    func offerAtIndex(index: Int) -> String? {
        
        guard index < (count - 1) else {
            return nil
        }
        
        var trueIndex: Int = 0
        
        for (i, value) in allValues.enumerate() {
            if value && trueIndex == index {
                return stringValues[i]
            } else {
                trueIndex++
            }
        }
        return nil
    }

}