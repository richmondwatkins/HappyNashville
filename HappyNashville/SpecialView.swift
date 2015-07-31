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
        
        let specialLabel: UILabel = UILabel()
        specialLabel.numberOfLines = 0

        var dateText: String = configureDateString(special);

        let dateAttrText: NSMutableAttributedString = NSMutableAttributedString(string: dateText)
        let dateFont: UIFont = UIFont(name: "GillSans", size: 12)!
        
        dateAttrText.addAttributes([NSFontAttributeName: dateFont],
            range: NSRange(location: 0, length: dateText.characters.count))
        
        let specialAttr: NSMutableAttributedString = NSMutableAttributedString(string: special.specialDescription)
        let specialFont: UIFont = UIFont(name: "GillSans-Light", size: 12)!
        
        specialAttr.addAttributes([NSFontAttributeName: specialFont],
            range: NSRange(location: 0, length: special.specialDescription.characters.count))
  
        specialAttr.appendAttributedString(dateAttrText)
        
        specialLabel.attributedText = specialAttr
        specialLabel.sizeToFit()
        specialLabel.frame = CGRectMake(9, 0, frame.size.width - 30, specialLabel.height)
        specialLabel.center = CGPointMake(specialLabel.center.x, self.height / 2)
       
        let typeBullet: UIView = UIView()
        typeBullet.layer.cornerRadius = 2
        typeBullet.frame = CGRectMake(0, 0, 6, 6)
        
        typeBullet.center = CGPointMake(0, self.height / 2)
        
        if special.type.integerValue != 6 {
            typeBullet.backgroundColor = UIColor(hexString: StringConstants.drinkColor)
        } else {
            typeBullet.backgroundColor = UIColor(hexString: StringConstants.foodColor)
        }
        
        self.addSubview(typeBullet)
        self.addSubview(specialLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDateString(special: Special) -> String {
        
        if special.allDay.boolValue {
            return " All Day"
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
        startDateFormatter.dateFormat = " h:mm"
        
        let endDateFormatter: NSDateFormatter = NSDateFormatter()
        endDateFormatter.dateFormat = "h:mm a"
        
        return "\(startDateFormatter.stringFromDate(startTime)) - \(endDateFormatter.stringFromDate(endTime))"
    }
}
