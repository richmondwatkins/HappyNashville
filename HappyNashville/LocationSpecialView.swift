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
    let padding: CGFloat = 8
    var containerView: UIView = UIView()
    
    init(special: Special, frame: CGRect) {
        super.init(frame: frame)
        
        dateView.text = configureDateString(special)
        dateView.font = UIFont.systemFontOfSize(10)
        dateView.textAlignment = NSTextAlignment.Center
        dateView.sizeToFit()
        
        specialView.text = special.specialDescription
        specialView.textAlignment = NSTextAlignment.Left
        specialView.font = UIFont.systemFontOfSize(14)
        specialView.sizeToFit()
        specialView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        specialView.numberOfLines = 2
        
        containerView.height = dateView.height + specialView.height + self.padding
        containerView.width = self.width
        
        self.frame = CGRectMake(0, 0, frame.size.width, dateView.height + specialView.height + self.padding)
        
        containerView.addSubview(dateView)
        containerView.addSubview(specialView)
        
        specialView.top = dateView.bottom + self.padding
        
        dateView.center = CGPointMake(self.width / 2, dateView.center.y)
        specialView.center = CGPointMake(self.width / 2, specialView.center.y)
        
        let underLineView: UIView = UIView(frame: CGRectMake(0, 0, dateView.width * 1.5, 1))
        
        if special.type.integerValue == 1 {
           underLineView.backgroundColor = UIColor(hexString: StringConstants.foodColor)
        } else {
            underLineView.backgroundColor = UIColor(hexString: StringConstants.drinkColor)
        }
        
        underLineView.center = CGPointMake(dateView.center.x, dateView.frame.origin.y + dateView.height)
        
        self.containerView.addSubview(underLineView)
        
        self.addSubview(containerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDateString(special: Special) -> String {
        
        if special.allDay.boolValue {
            return "All Day"
        }
        
        let startDateComponents: NSDateComponents = NSDateComponents()
        startDateComponents.hour = special.hourStart.integerValue
        startDateComponents.minute = special.minuteStart.integerValue
        startDateComponents.timeZone = NSTimeZone(abbreviation: "CT")
        
        let endDateComponents: NSDateComponents = NSDateComponents()
        endDateComponents.hour = special.hourEnd.integerValue
        endDateComponents.minute = special.minuteEnd.integerValue
        endDateComponents.timeZone = NSTimeZone(abbreviation: "CT")
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startTime: NSDate = calendar.dateFromComponents(startDateComponents)!
        let endTime: NSDate = calendar.dateFromComponents(endDateComponents)!
        
        let startDateFormatter: NSDateFormatter = NSDateFormatter()
        startDateFormatter.dateFormat = "h:mm"
        
        let endDateFormatter: NSDateFormatter = NSDateFormatter()
        endDateFormatter.dateFormat = "h:mm a"
        
        return "\(startDateFormatter.stringFromDate(startTime)) - \(endDateFormatter.stringFromDate(endTime))"
    }

}
