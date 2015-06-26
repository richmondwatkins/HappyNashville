//
//  APIManger.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 3/31/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import CoreData

class APIManger: NSObject {
    
    static var masterDealDaysArray: Array<DealDay> = []
    
    class func requestNewData(completed: (dealDays: Array<DealDay>, locations: Array<Location>) -> Void) {
        let urlString = "https://s3-us-west-2.amazonaws.com/nashvilledeals/deals.json"
        var url: NSURL = NSURL(string: urlString)!;
        var request: NSURLRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
                
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
            
                self.masterDealDaysArray.removeAll(keepCapacity: false)
                
                self.updateDeals(jsonResult["locations"] as! NSArray, completed: { (dealDays, locations) -> Void in
                    completed(dealDays: dealDays, locations: locations)
                })
        }

    }
    
    class func updateDeals(deals: NSArray, completed: (dealDays: Array<DealDay>, locations: Array<Location>) -> Void) {
        
        var locationArray: Array<Location> = []

        for location in deals as! [NSDictionary] {
            locationArray.append(createLocation(location))
        }
        
        completed(dealDays: self.masterDealDaysArray, locations: locationArray)
    }
    
    class func createLocation(locationDict: NSDictionary) -> Location {
        let location: Location = Location()
        
        for key in locationDict.allKeys as! [String] {
            if key != "_id" {
                if key == "dealDays" {
                    location.addDealDays(self.addDealDays(locationDict[key] as! NSArray, location: location) as Set<NSObject>)
                } else if key == "coords" {
                    var coordsDict: NSDictionary = locationDict[key] as! NSDictionary
                    location.lat = coordsDict["lat"] as! NSNumber
                    location.lng = coordsDict["lng"] as! NSNumber
                } else {
                    location.setValue(locationDict[key], forKey: key)
                }
            }
        }
        
        return location
    }
    
    class func addDealDays(dealDays: NSArray, location: Location) -> NSSet {
    
        var dealDaysArray: Array<DealDay> = []
        
        for dealDayDict in dealDays as! [NSDictionary] {
            
            var dealDay: DealDay = DealDay()
            
            self.masterDealDaysArray.append(dealDay)
            
            dealDaysArray.append(dealDay)
            
            dealDay.location = location
            
            for key in dealDayDict.allKeys as! [String] {
                
                if key == "specials" {
                    
                    dealDay.addSpecials(self.setSpecials(dealDayDict[key] as! NSArray) as Set<NSObject>)
                } else {

                    dealDay.setValue(dealDayDict[key], forKey: key)
                }
            }
            
        }
        
        return NSSet(array: dealDaysArray)
    }
    
    class func setSpecials(specials: NSArray) -> NSSet {
        
        var specialMutable: Array<Special> = []
        
        for  specialDict in specials as! [NSDictionary] {
            
            var special: Special = Special()
            
            for key in specialDict.allKeys as! [String] {
                special.setValue(specialDict[key], forKey: key)
            }
            
            specialMutable.append(special)
        }
        
        return NSSet(array: specialMutable)
    }

    class func fetchNotifications() -> NSArray? {
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Notification")
        
        return appDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
    }
    
    class func deletePastNotifications() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { ()->() in
            var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
            
            var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Notification")
            
            var notificationsArr: NSArray? = appDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
            
            if let notifications = notificationsArr {
                
                for notification in notificationsArr as! [Notification] {
                    
                    if notification.date.timeIntervalSince1970 < NSDate().timeIntervalSince1970 {
                        
                        appDelegate.managedObjectContext?.deleteObject(notification)
                    }
                }
                
                appDelegate.managedObjectContext?.save(nil)
            }
        })
    }
    
    class func deleteNotificationFromID(notifID: String) {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Notification")
        
        let predicate = NSPredicate(format: "notifId == %@", notifID)
        
        fetchRequest.predicate = predicate
        
        let results: NSArray = appDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [Notification]
        
        if results.count > 0 {
            let notif: Notification = results.firstObject as! Notification
            
            appDelegate.managedObjectContext?.deleteObject(notif)
            appDelegate.managedObjectContext?.save(nil)
        }
    }
    
    class func deleteNotification(notification: Notification) {
        
        var app:UIApplication = UIApplication.sharedApplication()

        for oneEvent in app.scheduledLocalNotifications {
            
            var localNotif = oneEvent as! UILocalNotification
            let userInfoCurrent = localNotif.userInfo!
            let uid = userInfoCurrent["notifId"] as! String
            
            if uid == notification.notifId {
                app.cancelLocalNotification(localNotif)
                break;
            }
        }

        var appDelegate: AppDelegate = app.delegate! as! AppDelegate

        appDelegate.managedObjectContext?.deleteObject(notification)
        
        appDelegate.managedObjectContext?.save(nil)
    }
}