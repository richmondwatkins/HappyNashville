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
    
    var date: NSDate?
    var isRecurring: Bool?
    var dealDay: DealDay?
    
    func calculateDatePickerDate(dealDay: DealDay) -> NSDate {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let date: NSDate = NSDate()
        let dateCompenents: NSDateComponents = gregorianCalendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Weekday , NSCalendarUnit.Day],
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
        
        let toDateComponents: NSDateComponents = gregorianCalendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Weekday , NSCalendarUnit.Day],
            fromDate: toDate)
        
        toDateComponents.hour = earliestSpecial.hourStart.integerValue - 1
        
        return gregorianCalendar.dateFromComponents(toDateComponents)!
    }
    
    func sendFirstReminder() {
        scheduleReminder(self.date!, isRecurring: self.isRecurring!, dealDay: self.dealDay!)
    }
    
    func scheduleReminder(date: NSDate, isRecurring: Bool, dealDay:DealDay) {
        
        if (!NSUserDefaults.standardUserDefaults().boolForKey("acceptedNotifications")) {
            self.date = date
            self.isRecurring = isRecurring
            self.dealDay = dealDay
            
            let notificationSetting = UIUserNotificationSettings(
                forTypes:[UIUserNotificationType.Alert,
                    UIUserNotificationType.Alert,
                    UIUserNotificationType.Sound],
                categories: nil
            )
            
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSetting)
        }
        
        let notification = UILocalNotification()
        notification.fireDate = date
        
        let alertTimeString: String = self.stringForEarliestSpecial(dealDay)
        var alertString: String!
        
        alertString = "\(dealDay.location.name) has specials\(alertTimeString)"
        
        notification.alertBody =  alertString // TODO: Add in special descriptions
        
        let notifId: String = randomString(10)
        notification.userInfo = ["notifId" : notifId, "day" : dealDay.day, "location" : dealDay.location.name]
        
        
        if isRecurring {
            notification.repeatInterval = NSCalendarUnit.WeekOfYear
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let notificationCD: Notification = NSEntityDescription.insertNewObjectForEntityForName("Notification", inManagedObjectContext: appDelegate.managedObjectContext) as! Notification
        
        notificationCD.text = notification.alertBody
        notificationCD.date = notification.fireDate
        notificationCD.notifId = notifId
        notificationCD.isRecurring = isRecurring
        notificationCD.locationName = dealDay.location.name
        dealDay.notification = notificationCD
        
        try! appDelegate.managedObjectContext.save()
    }
    
    func weekDayForTimePicker(date: NSDate) -> Int {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let dateCompenents: NSDateComponents = gregorianCalendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Weekday , NSCalendarUnit.Day],
            fromDate: date)
        
        return dateCompenents.weekday
    }
    
    func randomString (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : Array<String> = []
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.append("\(letters.characterAtIndex(Int(rand)))")
        }
        
        return randomString.joinWithSeparator("")
    }
}