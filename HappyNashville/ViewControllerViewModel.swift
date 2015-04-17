//
//  ViewControllerViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 3/31/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import CoreData

@objc protocol ViewModelProtocol {
    func reloadTable()
}


public class ViewControllerViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    var tableDataSource: Dictionary<Int, Array<DealDay>> = [:]
    var delegate: ViewModelProtocol?
    var tableSections: Array<Int> = []
    
    override init() {
        super.init()
        
        fetchData()
    }
    
    func fetchData() {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let fetchResult = APIManger.fetchAllDealDays(appDelegate.managedObjectContext!) {
           
           sortData(fetchResult)
        }
        
    }
    
    func sortData(fetchResult: NSArray) {
        
        var sundayArray: Array<DealDay> = []
        var mondayArray: Array<DealDay> = []
        var tuesdayArray: Array<DealDay> = []
        var wednesdayArray: Array<DealDay> = []
        var thursdayArray: Array<DealDay> = []
        var fridayArray: Array<DealDay> = []
        var saturdayArray: Array<DealDay> = []
        
        for deal in fetchResult as! [DealDay] {
            
            switch deal.day.integerValue {
                
            case 0:
                sundayArray.append(deal)
                    break
            case 1:
                mondayArray.append(deal)
                break
            case 2:
                tuesdayArray.append(deal)
                break
            case 3:
                wednesdayArray.append(deal)
                break
            case 4:
                thursdayArray.append(deal)
                break
            case 5:
                fridayArray.append(deal)
                break
            case 6:
                saturdayArray.append(deal)
                break
            default:
                break
            }
        }
        
        if sundayArray.count > 0 {
            self.tableDataSource[0] = sundayArray
        }
        
        if mondayArray.count > 0 {
            self.tableDataSource[1] = mondayArray
        }
        
        if tuesdayArray.count > 0 {
            self.tableDataSource[2] = tuesdayArray
        }
        
        if wednesdayArray.count > 0 {
            self.tableDataSource[4] = wednesdayArray
        }
        
        if thursdayArray.count > 0 {
            self.tableDataSource[5] = thursdayArray
        }
        
        if fridayArray.count > 0 {
            self.tableDataSource[6] = fridayArray
        }
        
        if saturdayArray.count > 0 {
            self.tableDataSource[7] = saturdayArray
        }
        
        self.tableSections =  self.tableDataSource.keys.array
    }
    
    func unscheduleNotification(dealDay: DealDay) {
        
        let application: UIApplication = UIApplication.sharedApplication()
        
        let scheduledNotifications: NSArray = application.scheduledLocalNotifications as NSArray
        
        for notifcation in scheduledNotifications as! [UILocalNotification] {
            
            if (dealDay.notification != nil) && (notifcation.fireDate == dealDay.notification.date) && dealDay.notification.text == notifcation.alertBody {
                
                 application.cancelLocalNotification(notifcation)
                
                let appDelegate: AppDelegate = application.delegate as! AppDelegate
                
                appDelegate.managedObjectContext!.deleteObject(dealDay.notification)
                
                appDelegate.managedObjectContext!.save(nil)
            }
        }
    }
    
    
    func sortSpecialsByTime(specials: NSSet) -> NSArray {
        
        var specialsArray: NSMutableArray = NSMutableArray(array: specials.allObjects)
        
        return NSArray(array: specials.sortedArrayUsingDescriptors([NSSortDescriptor(key: "hourStart", ascending: true)]))
    }
    
    func dayForDayNumber(dayNumber: Int) -> String {
        
        var dayString: String = String()
        
        switch dayNumber {
            case 0:
                dayString = "Sunday"
                break;
            case 1:
                dayString = "Monday"
                break;
            case 2:
                dayString = "Tuesday"
                break;
            case 3:
                dayString = "Wednesday"
                break;
            case 4:
                dayString = "Thursday"
                break;
            case 5:
                dayString = "Friday"
                break;
            case 6:
                dayString = "Saturday"
                break;
            default:
                break;
        }
        
        return dayString
    }
    
    func getButtonWidth(parentViewWidth: CGFloat) -> (buttonWidth: CGFloat, buttonPadding: CGFloat) {
        
        let numberOfButtons: CGFloat = 3
        
        let paddingSeperators: CGFloat = 2
        
        var buttonPadding:CGFloat = 5 * paddingSeperators
        
        var buttonWidth:CGFloat = (parentViewWidth - buttonPadding) / numberOfButtons
        
        return (buttonWidth, 5)
    }
    
    func getCurrentDay() -> Int {
        
        var calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        
        var dateComponents = calendar!.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: NSDate())
        
        return dateComponents.weekday
    }
}
