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


 class ViewControllerViewModel: AppViewModel, NSFetchedResultsControllerDelegate {
    
    var tableDataSource: Dictionary<Int, Array<DealDay>> = [:]
    var originalDataSource: Dictionary<Int, Array<DealDay>> = [:]
    var delegate: ViewModelProtocol?
    var tableSections: Array<Int> = []
    var unformattedData: Array<DealDay>!
    
    override init() {
        super.init()
        
        fetchData()
    }
    
    func fetchData() {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let fetchResult = APIManger.fetchAllDealDays(appDelegate.managedObjectContext!) {
           
            var swiftArray = fetchResult.mutableCopy() as AnyObject as! [DealDay]
            
            self.unformattedData = swiftArray
            
            sortData(swiftArray)
        }
        
    }
    
    func sortData(fetchResult: Array<DealDay>) {
        
        var sundayArray: Array<DealDay> = []
        var mondayArray: Array<DealDay> = []
        var tuesdayArray: Array<DealDay> = []
        var wednesdayArray: Array<DealDay> = []
        var thursdayArray: Array<DealDay> = []
        var fridayArray: Array<DealDay> = []
        var saturdayArray: Array<DealDay> = []
        
        for deal in fetchResult {
            
            switch deal.day.integerValue {
                
            case 1:
                sundayArray.append(deal)
                    break
            case 2:
                mondayArray.append(deal)
                break
            case 3:
                tuesdayArray.append(deal)
                break
            case 4:
                wednesdayArray.append(deal)
                break
            case 5:
                thursdayArray.append(deal)
                break
            case 6:
                fridayArray.append(deal)
                break
            case 7:
                saturdayArray.append(deal)
                break
            default:
                break
            }
        }
        
        if sundayArray.count > 0 {
            self.tableDataSource[1] = sundayArray
        }
        
        if mondayArray.count > 0 {
            self.tableDataSource[2] = mondayArray
        }
        
        if tuesdayArray.count > 0 {
            self.tableDataSource[3] = tuesdayArray
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
        
        self.tableSections.sort {
            return $0 < $1
        }
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
    
    func sortByFoodOnly() {
        resetSort()
        self.originalDataSource = self.tableDataSource
        
        for (key, value) in self.originalDataSource {
            
            for dealDay in value {
                if dealDay.type.integerValue != 1 {
                    var arr: Array<DealDay> = self.tableDataSource[key]!
                    self.tableDataSource[key]?.removeAtIndex(find(arr, dealDay)!)
                }
            }
        }
    }
    
    func sortByDrinkOnly() {
        resetSort()
        
        self.originalDataSource = self.tableDataSource
        
        for (key, value) in self.originalDataSource {
            
            for dealDay in value {
                if dealDay.type.integerValue != 0 {
                    var arr: Array<DealDay> = self.tableDataSource[key]!
                    self.tableDataSource[key]?.removeAtIndex(find(arr, dealDay)!)
                }
            }
        }
    }
    
    func sortByRating() {
        resetSort()
        
        self.originalDataSource = self.tableDataSource
        
        self.unformattedData = sorted(self.unformattedData) { ($0.location.rating.integerValue as Int) > ($1.location.rating.integerValue as Int) }
        
    }
    
    func sortAlphabetically() {
        resetSort()
        
        self.originalDataSource = self.tableDataSource
        
        self.unformattedData = sorted(self.unformattedData) { ($0.location.name as String) < ($1.location.name as String) }
    }
    
    func resetSort() {
        if self.originalDataSource.count > 0 {
            self.tableDataSource = self.originalDataSource
        }
    }
    
}
