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
        specialLabel.font = UIFont.systemFontOfSize(10)
        specialLabel.numberOfLines = 0
        
        var dateText: String = configureDateString(special);
        var text: String = special.specialDescription + " " + dateText;
        var attributedText: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(10)], range: NSRange(location: count(special.specialDescription) + 1, length: count(dateText)))
  
        specialLabel.attributedText = attributedText
        
        specialLabel.sizeToFit()
        specialLabel.frame = CGRectMake(9, 0, frame.size.width - 30, specialLabel.height)
        specialLabel.center = CGPointMake(specialLabel.center.x, self.height / 2)
       
        var typeBullet: UIView = UIView()
        typeBullet.layer.cornerRadius = 2
        typeBullet.frame = CGRectMake(0, 0, 6, 6)
        
        typeBullet.center = CGPointMake(0, self.height / 2)
        
        if special.type.integerValue == 0 {
            typeBullet.backgroundColor = UIColor(hexString: StringConstants.drinkColor)
        } else {
            typeBullet.backgroundColor = UIColor(hexString: StringConstants.foodColor)
        }
        
        self.addSubview(typeBullet)
        self.addSubview(specialLabel)
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
        startDateFormatter.dateFormat = "h:mm"
        
        var endDateFormatter: NSDateFormatter = NSDateFormatter()
        endDateFormatter.dateFormat = "h:mm a"
        
        return "\(startDateFormatter.stringFromDate(startTime)) - \(endDateFormatter.stringFromDate(endTime))"
    }
    
    
}
