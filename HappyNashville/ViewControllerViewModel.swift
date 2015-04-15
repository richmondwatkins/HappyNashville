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
    
    var tableDataSource: Dictionary<String,Array<DealDay>> = [:]
    var delegate: ViewModelProtocol?
    var tableSections: Array<String> = []
    
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
            self.tableDataSource["Sunday"] = sundayArray
        }
        
        if mondayArray.count > 0 {
            self.tableDataSource["Monday"] = mondayArray
        }
        
        if tuesdayArray.count > 0 {
            self.tableDataSource["Tuesday"] = tuesdayArray
        }
        
        if wednesdayArray.count > 0 {
            self.tableDataSource["Wednesday"] = wednesdayArray
        }
        
        if thursdayArray.count > 0 {
            self.tableDataSource["Thursday"] = thursdayArray
        }
        
        if fridayArray.count > 0 {
            self.tableDataSource["Friday"] = fridayArray
        }
        
        if saturdayArray.count > 0 {
            self.tableDataSource["Saturday"] = saturdayArray
        }
        
        
        self.tableSections = self.tableDataSource.keys.array
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
    
    
}
