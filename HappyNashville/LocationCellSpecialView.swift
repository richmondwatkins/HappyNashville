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
        
        let titleOrigin: CGPoint = CGPointMake(10, 10);
        title.drawAtPoint(titleOrigin, withAttributes: titleAttributes)
        
        var top: CGFloat = titleOrigin.y + 21

        //TODO: add sorting
        for special in self.dealDay.specials.allObjects as! [Special] {
            
            let bulletPoint: CALayer = CALayer()
            
            var typeBullet: CALayer = CALayer()
            typeBullet.cornerRadius = 2
            typeBullet.frame = CGRectMake(5, top + 5, 6, 6)
            
            var bulletColor: UIColor!
            if special.type.integerValue != 6 {
                bulletColor = UIColor(hexString: StringConstants.drinkColor)
            } else {
                bulletColor = UIColor(hexString: StringConstants.foodColor)
            }
            
            let box: CGRect = CGRectMake(5, top + 4, 6, 6)
            let bulletPath: UIBezierPath = UIBezierPath(roundedRect: box, cornerRadius: 2)
            bulletColor.setStroke()
            bulletColor.setFill()
            bulletPath.stroke()
            bulletPath.fill()
            
            let dateText = self.configureDateString(special)
            var dateAttrText: NSMutableAttributedString = NSMutableAttributedString(string: dateText)
            let dateFont: UIFont = UIFont(name: "GillSans", size: 12)!
            
            dateAttrText.addAttributes([NSFontAttributeName: dateFont],
                range: NSRange(location: 0, length: count(dateText)))
            
            var specialAttr: NSMutableAttributedString = NSMutableAttributedString(string: special.specialDescription)
            let specialFont: UIFont = UIFont(name: "GillSans-Light", size: 12)!
            
            specialAttr.appendAttributedString(dateAttrText)
            
            specialAttr.drawAtPoint(CGPointMake(titleOrigin.x + 6, top))

            top += 22
        }
    }
    
    func configureDateString(special: Special) -> String {
        
        if special.allDay.boolValue {
            return " All Day"
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
        startDateFormatter.dateFormat = " h:mm"
        
        var endDateFormatter: NSDateFormatter = NSDateFormatter()
        endDateFormatter.dateFormat = "h:mm a"
        
        return "\(startDateFormatter.stringFromDate(startTime)) - \(endDateFormatter.stringFromDate(endTime))"
    }
}
