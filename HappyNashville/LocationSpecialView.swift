//
//  LocationSpecialView.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/18/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class LocationSpecialView: UIView {
    
    var dateView: UILabel = UILabel()
    var specialView: UILabel = UILabel()
    let padding: CGFloat = 4
    var containerView: UIView = UIView()
    
    init(special: Special, frame: CGRect) {
        super.init(frame: frame)
        
        dateView.text = configureDateString(special)
        dateView.font = UIFont.systemFontOfSize(10)
        dateView.frame = CGRectMake(0, 0, self.width, 10)
        dateView.textAlignment = NSTextAlignment.Center
        
        specialView.text = special.specialDescription
        specialView.textAlignment = NSTextAlignment.Center
        specialView.numberOfLines = 0
        specialView.sizeToFit()
        
        containerView.height = dateView.height + specialView.height + self.padding
        containerView.width = self.width
        
        self.frame = CGRectMake(0, 0, frame.size.width, dateView.height + specialView.height + self.padding)
        
        containerView.addSubview(dateView)
        containerView.addSubview(specialView)
        
        specialView.top = dateView.bottom + self.padding
        
        dateView.center = CGPointMake(self.width / 2, dateView.center.y)
        specialView.center = CGPointMake(self.width / 2, specialView.center.y)
        
        self.addSubview(containerView)
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
