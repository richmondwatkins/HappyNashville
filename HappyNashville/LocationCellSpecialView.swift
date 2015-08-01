//
//  LocationCellSpecialView.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 7/21/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class LocationCellSpecialView: UIView {

    var dealDay: DealDay!

    override func drawRect(rect: CGRect) {
        let titleFont: UIFont = UIFont(name: "GillSans", size: 16)!
        let titleAttributes = [NSFontAttributeName : titleFont]
        let title: NSString = self.dealDay.location.name as NSString
        let titleOrigin: CGPoint = CGPointMake(8, 10);
        
        title.drawAtPoint(titleOrigin, withAttributes: titleAttributes)
        
        var top: CGFloat = titleOrigin.y + 23

        for special in self.dealDay.specials.allObjects as! [Special] {
  
            var bulletColor: UIColor!
            if special.type.integerValue != 6 {
                bulletColor = UIColor(hexString: StringConstants.drinkColor)
            } else {
                bulletColor = UIColor(hexString: StringConstants.foodColor)
            }
            
            let box: CGRect = CGRectMake(5, top + 5, 4, 4)
            let bulletPath: UIBezierPath = UIBezierPath(roundedRect: box, cornerRadius: 2)
            bulletColor.setStroke()
            bulletColor.setFill()
            bulletPath.stroke()
            bulletPath.fill()

            let specialFont: UIFont = UIFont(name: "GillSans", size: 12)!
            let specialAttrs = [NSFontAttributeName : specialFont]
            let specialText: NSString = special.specialDescription as NSString
            let specialPoint: CGPoint = CGPointMake(titleOrigin.x + 6, top)
            
            specialText.drawAtPoint(specialPoint, withAttributes: specialAttrs)
            
            let specialSize: CGSize = specialText.sizeWithAttributes(specialAttrs)
            
            let dateText: NSString = self.configureDateString(special)
            let dateFont: UIFont = UIFont(name: "GillSans", size: 10)!
            let dateAttrs = [NSFontAttributeName : dateFont]
            
            dateText.drawAtPoint(CGPoint(x: specialPoint.x + specialSize.width + 2, y: specialPoint.y + 2), withAttributes: dateAttrs)
            
            top += 22
        }
    }
    
    func configureDateString(special: Special) -> NSString {
        
        if special.allDay.boolValue {
            return " - All Day"
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
        startDateFormatter.dateFormat = " - h:mm a"
        
        let endDateFormatter: NSDateFormatter = NSDateFormatter()
        endDateFormatter.dateFormat = "h:mm a"
        
        return "\(startDateFormatter.stringFromDate(startTime)) - \(endDateFormatter.stringFromDate(endTime))"
    }
}
