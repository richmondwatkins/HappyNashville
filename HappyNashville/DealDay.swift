//
//  DealDay.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/5/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

public class DealDay: NSObject {
   
    public var day: NSNumber = 0.0;
    public var type: NSNumber = 0.0;
    public var height: NSNumber = 0.0;
    public var isOpen: NSNumber = 0.0;
    public var location: Location!
    public var notification: Notification!
    public var specials: NSSet = [];

    public func addSpecials(specials: NSSet) {
        self.specials = specials
    }

}
