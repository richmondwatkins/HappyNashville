//
//  ScheduleViewControllerViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/3/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewControllerViewModel: NSObject {
   
    func calculateDatePickerDate(deal: Deal) -> NSDate {
        
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let date: NSDate = NSDate()
        let dateCompenents: NSDateComponents = gregorianCalendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.WeekCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit | NSCalendarUnit.DayCalendarUnit,
            fromDate: date)
        
        var daysToNextOccur = 0
        
        if deal.day.integerValue + 1 < dateCompenents.weekday {
            
            daysToNextOccur = 7 - (dateCompenents.weekday - deal.day.integerValue + 1)
        } else {
            
            daysToNextOccur = dateCompenents.weekday - deal.day.integerValue + 1
        }
        
        let timeToDate: Int = 60 * 60 * 24 * daysToNextOccur
        
        let toDate: NSDate = date.dateByAddingTimeInterval(NSTimeInterval(timeToDate))
        
        let toDateComponents: NSDateComponents = gregorianCalendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.WeekCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit | NSCalendarUnit.DayCalendarUnit,
            fromDate: toDate)
        
        toDateComponents.hour = 12
 
        return gregorianCalendar.dateFromComponents(toDateComponents)!
    }
    
    func scheduleReminder(date: NSDate, isRecurring: Bool, deal:Deal) {
        
        let notificationSetting = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Alert | UIUserNotificationType.Sound, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSetting)
        
        var notification = UILocalNotification()
        notification.fireDate = date
        notification.alertBody = "\(deal.location.name)" // TODO: Add in special descriptions

        if isRecurring {
            notification.repeatInterval = NSCalendarUnit.WeekCalendarUnit
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
     
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        var notificationCD: Notification = NSEntityDescription.insertNewObjectForEntityForName("Notification", inManagedObjectContext: appDelegate.managedObjectContext!) as Notification
        
        notificationCD.text = notification.alertBody
        notificationCD.date = notification.fireDate
        notificationCD.deal = deal
        
        deal.notification = notificationCD
        
        appDelegate.managedObjectContext!.save(nil)
        
        
    }
}
