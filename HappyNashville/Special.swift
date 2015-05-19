//
//  Special.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/5/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

public class Special: NSObject {
   
    public var allDay: NSNumber = 0.0
    public var hourEnd: NSNumber = 0.0
    public var hourStart: NSNumber = 0.0
    public var minuteStart: NSNumber = 0.0
    public var minuteEnd: NSNumber = 0.0
    public var specialDescription: String = ""
    public var specialPrice: String = ""
    public var specialItem: String = ""
    public var dealDay: DealDay!
    public var type: NSNumber = 0.0
}
