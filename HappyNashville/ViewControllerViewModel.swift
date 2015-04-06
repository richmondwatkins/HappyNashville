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
    
    var tableDataSource: NSMutableDictionary = NSMutableDictionary()
    var delegate: ViewModelProtocol?
    var tableSections: NSArray?
    
    override init() {
        super.init()
        
        fetchData()
    }
    
    func fetchData() {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if let fetchResult = APIManger.fetchAllDeals(appDelegate.managedObjectContext!) {
           
           sortData(fetchResult)
        }
        
    }
    
    func sortData(fetchResult: NSArray) {
        
        var sundayArray: NSMutableArray = []
        var mondayArray: NSMutableArray = []
        var tuesdayArray: NSMutableArray = []
        var wednesdayArray: NSMutableArray = []
        var thursdayArray: NSMutableArray = []
        var fridayArray: NSMutableArray = []
        var saturdayArray: NSMutableArray = []
        
        for deal in fetchResult as [Deal] {
            
            switch deal.day.integerValue {
                
            case 0:
                sundayArray.addObject(deal)
                    break
            case 1:
                mondayArray.addObject(deal)
                break
            case 2:
                tuesdayArray.addObject(deal)
                break
            case 3:
                wednesdayArray.addObject(deal)
                break
            case 4:
                thursdayArray.addObject(deal)
                break
            case 5:
                fridayArray.addObject(deal)
                break
            case 6:
                saturdayArray.addObject(deal)
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
        
        
        self.tableSections = self.tableDataSource.allKeys
    }
    
    func unscheduleNotification(deal: Deal) {
        
        let application: UIApplication = UIApplication.sharedApplication()
        
        let scheduledNotifications: NSArray = application.scheduledLocalNotifications as NSArray
        
        for notifcation in scheduledNotifications as [UILocalNotification] {
            
            if (deal.notification != nil) && (notifcation.fireDate == deal.notification.date) && deal.notification.text == notifcation.alertBody {
                
                 application.cancelLocalNotification(notifcation)
                
                let appDelegate: AppDelegate = application.delegate as AppDelegate
                
                appDelegate.managedObjectContext!.deleteObject(deal.notification)
                
                appDelegate.managedObjectContext!.save(nil)
            }
        }
    }
    
    
    func sortSpecialsByTime(specials: NSSet) -> NSArray {
        
        var specialsArray: NSMutableArray = NSMutableArray(array: specials.allObjects)
        
        return NSArray(array: specials.sortedArrayUsingDescriptors([NSSortDescriptor(key: "hourStart", ascending: true)]))
    }
    
    
}
