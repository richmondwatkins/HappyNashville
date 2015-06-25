//
//  ScheduleViewControllerViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/3/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewControllerViewModel: AppViewModel {
   
    func calculateDatePickerDate(dealDay: DealDay) -> NSDate {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let date: NSDate = NSDate()
        let dateCompenents: NSDateComponents = gregorianCalendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.WeekCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit | NSCalendarUnit.DayCalendarUnit,
            fromDate: date)
        
        var daysToNextOccur = 0
        
        let earliestSpecial: Special = self.getEaliestSpecial(dealDay.specials)
        
        if earliestSpecial.allDay.boolValue {
            dealDay.day = NSNumber(int: dealDay.day.integerValue + 1)
        }
        
        if dealDay.day.integerValue < dateCompenents.weekday {
            
            daysToNextOccur =  7 - dateCompenents.weekday + dealDay.day.integerValue
        } else {
            
            daysToNextOccur =  dealDay.day.integerValue - dateCompenents.weekday
        }
        
        let timeToDate: Int = 60 * 60 * 24 * daysToNextOccur
        
        let toDate: NSDate = date.dateByAddingTimeInterval(NSTimeInterval(timeToDate))
        
        let toDateComponents: NSDateComponents = gregorianCalendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.WeekCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit | NSCalendarUnit.DayCalendarUnit,
            fromDate: toDate)
        
        toDateComponents.hour = earliestSpecial.hourStart.integerValue - 1
 
        return gregorianCalendar.dateFromComponents(toDateComponents)!
    }
    
    func scheduleReminder(date: NSDate, isRecurring: Bool, dealDay:DealDay) {
        
        let notificationSetting = UIUserNotificationSettings(
            forTypes: UIUserNotificationType.Alert |
                UIUserNotificationType.Alert |
                UIUserNotificationType.Sound,
            categories: nil
        )
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSetting)
        
        var notification = UILocalNotification()
        notification.fireDate = date

        var alertTimeString: String = self.stringForEarliestSpecial(dealDay)
        var alertString: String!
    
        alertString = "\(dealDay.location.name) has specials\(alertTimeString)"
        
        notification.alertBody =  alertString // TODO: Add in special descriptions
        
        let notifId: String = randomString(10)
        notification.userInfo = ["notifId" : notifId, "day" : dealDay.day, "location" : dealDay.location.name]


        if isRecurring {
            notification.repeatInterval = NSCalendarUnit.WeekCalendarUnit
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
     
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var notificationCD: Notification = NSEntityDescription.insertNewObjectForEntityForName("Notification", inManagedObjectContext: appDelegate.managedObjectContext!) as! Notification
        
        notificationCD.text = notification.alertBody
        notificationCD.date = notification.fireDate
        notificationCD.notifId = notifId
        notificationCD.isRecurring = isRecurring
        notificationCD.locationName = dealDay.location.name
        dealDay.notification = notificationCD
        
        appDelegate.managedObjectContext!.save(nil)
    }
    
    func weekDayForTimePicker(date: NSDate) -> Int {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let dateCompenents: NSDateComponents = gregorianCalendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.WeekCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit | NSCalendarUnit.DayCalendarUnit,
            fromDate: date)
        
        return dateCompenents.weekday
    }
    
    func randomString (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : Array<String> = []
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.append("\(letters.characterAtIndex(Int(rand)))")
        }
        
        return "".join(randomString)
    }
}
