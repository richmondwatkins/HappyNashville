//
//  Location.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/5/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

public class Location: NSObject {
    
    public var address: String = "";
    public var lat: NSNumber = 0.0;
    public var lng: NSNumber = 0.0;
    public var name: String = "";
    public var phoneNumber: String = "";
    public var rating: NSNumber = 0.0;
    public var priceLevel: NSNumber = 0.0
    public var slug: String = "";
    public var website: String = "";
    public var dealDays: NSSet = [];

    
    public func addDealDays(dealDays: NSSet) {
        self.dealDays = dealDays
    }

}
