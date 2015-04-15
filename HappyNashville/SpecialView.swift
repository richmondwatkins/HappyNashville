//
//  SpecialView.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/5/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class SpecialView: UIView {

    init(special: Special, frame: CGRect) {
        super.init(frame: frame)
        
        var specialLabel: UILabel = UILabel()
        specialLabel.text = special.specialDescription
        specialLabel.font = UIFont.systemFontOfSize(10)
        specialLabel.sizeToFit()
        specialLabel.frame = CGRectMake(0, 0, specialLabel.width, specialLabel.height)
        
       
        
        var dateLabel: UILabel = UILabel()
        dateLabel.font = UIFont.boldSystemFontOfSize(10)
        dateLabel.text = configureDateString(special)
        dateLabel.sizeToFit()
        dateLabel.left = specialLabel.right + 5
        
        self.addSubview(specialLabel)
        self.addSubview(dateLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDateString(special: Special) -> String {
        
        if special.allDay.boolValue {
            return "All Day"
        }
        
        var startDateComponents: NSDateComponents = NSDateComponents()
        startDateComponents.hour = special.hourStart.integerValue
        startDateComponents.minute = special.minuteStart.integerValue
        startDateComponents.timeZone = NSTimeZone(abbreviation: "CT")
        
        var endDateComponents: NSDateComponents = NSDateComponents()
        endDateComponents.hour = special.hourEnd.integerValue
        endDateComponents.minute = special.minuteEnd.integerValue
        endDateComponents.timeZone = NSTimeZone(abbreviation: "CT")
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var startTime: NSDate = calendar.dateFromComponents(startDateComponents)!
        var endTime: NSDate = calendar.dateFromComponents(endDateComponents)!
        
        var startDateFormatter: NSDateFormatter = NSDateFormatter()
        startDateFormatter.dateFormat = "hh:mm"
        
        var endDateFormatter: NSDateFormatter = NSDateFormatter()
        endDateFormatter.dateFormat = "hh:mm a"
        
        return "\(startDateFormatter.stringFromDate(startTime)) - \(endDateFormatter.stringFromDate(endTime))"
    }
    
    
}
