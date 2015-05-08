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
        
        if dealDay.day.integerValue < dateCompenents.weekday {
              daysToNextOccur =  7 - dateCompenents.weekday + dealDay.day.integerValue
//            daysToNextOccur = 7 - (dateCompenents.weekday - dealDay.day.integerValue)
        } else {
            
            daysToNextOccur =  dealDay.day.integerValue - dateCompenents.weekday
        }
        
        let timeToDate: Int = 60 * 60 * 24 * daysToNextOccur
        
        let toDate: NSDate = date.dateByAddingTimeInterval(NSTimeInterval(timeToDate))
        
        let toDateComponents: NSDateComponents = gregorianCalendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.WeekCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit | NSCalendarUnit.DayCalendarUnit,
            fromDate: toDate)
        
        
        let special: Special = self.sortSpecialsByTime(dealDay.specials)[0] as! Special
        
        toDateComponents.hour = special.hourStart.integerValue - 1
 
        return gregorianCalendar.dateFromComponents(toDateComponents)!
    }
    
    func scheduleReminder(date: NSDate, isRecurring: Bool, dealDay:DealDay) {
        
        let notificationSetting = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Alert | UIUserNotificationType.Sound, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSetting)
        
        var notification = UILocalNotification()
        notification.fireDate = date
        notification.alertBody = "\(dealDay.location.name)" // TODO: Add in special descriptions
        
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
        dealDay.notification = notificationCD
        
        appDelegate.managedObjectContext!.save(nil)
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
