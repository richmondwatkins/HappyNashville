//
//  AppViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/19/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class AppViewModel: NSObject {
   
    
    func getCurrentDay() -> Int {
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        
        let dateComponents = calendar!.components(NSCalendarUnit.Weekday, fromDate: NSDate())
        
        return dateComponents.weekday
    }
    
    func sortSpecialsByTime(specials: NSSet) -> NSArray {
        
        var specialsArray: NSMutableArray = NSMutableArray(array: specials.allObjects)
        
        return NSArray(array: specials.sortedArrayUsingDescriptors([NSSortDescriptor(key: "hourStart", ascending: true)]))
    }
    
    func getButtonWidth(parentViewWidth: CGFloat, numberOfButtons: CGFloat, padding: CGFloat) -> (buttonWidth: CGFloat, buttonPadding: CGFloat) {
        
        let paddingSeperators: CGFloat = numberOfButtons + 1
        
        let buttonPadding:CGFloat = padding * paddingSeperators
        
        let buttonWidth:CGFloat = (parentViewWidth - buttonPadding) / numberOfButtons
        
        return (buttonWidth, padding)
    }
    
    func getEaliestSpecial(specials: NSSet) -> Special {
        
        let specialArr: NSArray = sortSpecialsByTime(specials)
        
        var special = specialArr.firstObject as! Special
        
        for nextSpecial in specialArr as! [Special] {
            if nextSpecial.allDay.integerValue != 1 {
                special = nextSpecial
                break
            }
        }
        
        return special
    }
    
    func dayForDayNumber(dayNumber: Int) -> String {
        
        var dayString: String = String()
        
        switch dayNumber {
        case 1:
            dayString = "Sunday"
            break;
        case 2:
            dayString = "Monday"
            break;
        case 3:
            dayString = "Tuesday"
            break;
        case 4:
            dayString = "Wednesday"
            break;
        case 5:
            dayString = "Thursday"
            break;
        case 6:
            dayString = "Friday"
            break;
        case 7:
            dayString = "Saturday"
            break;
        default:
            break;
        }
        
        return dayString
    }
    
    func stringForEarliestSpecial(dealDay: DealDay) -> String {
        let sorted: NSArray = sortSpecialsByTime(dealDay.specials)
        
        return configureDateString(sorted.firstObject as! Special, dealDay: dealDay)
    }
    
    func configureDateString(special: Special, dealDay: DealDay) -> String {
        
        let startDateComponents: NSDateComponents = NSDateComponents()
        startDateComponents.hour = special.hourStart.integerValue
        startDateComponents.minute = special.minuteStart.integerValue
        startDateComponents.timeZone = NSTimeZone(abbreviation: "CT")
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startTime: NSDate = calendar.dateFromComponents(startDateComponents)!
        
        let startDateFormatter: NSDateFormatter = NSDateFormatter()
        startDateFormatter.dateFormat = "h:mm"
        
        var returnString: String!
        
        if special.allDay.boolValue {
            returnString =  " all day on \(dayForDayNumber(dealDay.day.integerValue))"
        } else {
            returnString =  " on \(dayForDayNumber(dealDay.day.integerValue)) at \(startDateFormatter.stringFromDate(startTime))"
        }
        
        return returnString
    }
}
