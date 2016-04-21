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
        let url: NSURL = NSURL(string: urlString)!;
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch") {
            self.updateDeals(self.copyFromBundleAndReturnData()!["locations"] as! NSArray, completed: { (dealDays, locations) -> Void in
                completed(dealDays: dealDays, locations: locations)
            })
        } else {
            
            self.updateDeals(self.loadDataFromFileSystem()!["locations"] as! NSArray, completed: { (dealDays, locations) -> Void in
                completed(dealDays: dealDays, locations: locations)
            })
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            var jsonResult: NSDictionary?
            
            self.masterDealDaysArray.removeAll(keepCapacity: false)
            
            if error == nil && data != nil {
                jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                self.writeNewDataToFile(jsonResult!)
            }
        }
        task.resume()
    }
    
    class func writeNewDataToFile(jsonDictionary: NSDictionary) {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: NSString = paths.objectAtIndex(0) as! NSString
        
        let fileSystemDataPath = documentsDirectory.stringByAppendingPathComponent("data.json")
        
        let newData: NSData? = try! NSJSONSerialization.dataWithJSONObject(jsonDictionary, options: NSJSONWritingOptions())
        
        if newData != nil {
            let jsonString: NSString? = NSString(data: newData!, encoding: NSUTF8StringEncoding)
            
            if (jsonString != nil) {
                try! jsonString!.writeToFile(fileSystemDataPath, atomically: true, encoding: NSUTF8StringEncoding)
            }
        }
    }
    
    class func copyFromBundleAndReturnData() -> NSDictionary? {
        let dataPath: String = NSBundle.mainBundle().pathForResource("data", ofType: "json")!
        
        let fileManger: NSFileManager = NSFileManager.defaultManager()
        
        let fileSystemDataPath = returnDataPath()
        
        try! fileManger.copyItemAtPath(dataPath, toPath: fileSystemDataPath)
        
        let jsonString: String = try! String(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding)
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setBool(true, forKey: "FirstLaunch")
        userDefaults.synchronize()
        
        return try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
    }
    
    class func loadDataFromFileSystem() -> NSDictionary? {
        let fileSystemDataPath = returnDataPath()
        
        let jsonString: String? = try! String(contentsOfFile: fileSystemDataPath, encoding: NSUTF8StringEncoding)
        
        if jsonString == nil {
            return copyFromBundleAndReturnData()
        }
        
        let data: NSData? = jsonString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if data != nil {
            let jsonDict: NSDictionary? = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            
            if jsonDict != nil {
                return jsonDict
            }
            
            return loadBackUpData()
        }
        
        return loadBackUpData()
    }
    
    class func loadBackUpData() -> NSDictionary? {
        let dataPath: String = NSBundle.mainBundle().pathForResource("data", ofType: "json")!
        let jsonString: String = try! String(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding)
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        return try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
    }
    
    class func returnDataPath() ->String {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: NSString = paths.objectAtIndex(0) as! NSString
        
        return documentsDirectory.stringByAppendingPathComponent("data.json")
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
                    let coordsDict: NSDictionary = locationDict[key] as! NSDictionary
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
            
            let dealDay: DealDay = DealDay()
            
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
            
            let special: Special = Special()
            
            for key in specialDict.allKeys as! [String] {
                special.setValue(specialDict[key], forKey: key)
            }
            
            specialMutable.append(special)
        }
        
        return NSSet(array: specialMutable)
    }
    
    class func fetchNotifications() -> NSArray? {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Notification")
        
        return try! appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
    }
    
    class func deletePastNotifications() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { ()->() in
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
            
            let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Notification")
            
            let notificationsArr: NSArray? = try! appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if let _ = notificationsArr {
                
                for notification in notificationsArr as! [Notification] {
                    
                    if notification.date.timeIntervalSince1970 < NSDate().timeIntervalSince1970 {
                        
                        appDelegate.managedObjectContext.deleteObject(notification)
                    }
                }
                
                try! appDelegate.managedObjectContext.save()
            }
        })
    }
    
    class func deleteNotificationFromID(notifID: String) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Notification")
        
        let predicate = NSPredicate(format: "notifId == %@", notifID)
        
        fetchRequest.predicate = predicate
        
        let results: NSArray = try! appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [Notification]
        
        if results.count > 0 {
            let notif: Notification = results.firstObject as! Notification
            
            appDelegate.managedObjectContext.deleteObject(notif)
            try! appDelegate.managedObjectContext.save()
        }
    }
    
    class func deleteNotification(notification: Notification) {
        
        let app:UIApplication = UIApplication.sharedApplication()
        
        if let notifs = app.scheduledLocalNotifications {
         
            for oneEvent in notifs {
                
                let localNotif = oneEvent
                let userInfoCurrent = localNotif.userInfo!
                let uid = userInfoCurrent["notifId"] as! String
                
                if uid == notification.notifId {
                    app.cancelLocalNotification(localNotif)
                    break;
                }
            }
            
            let appDelegate: AppDelegate = app.delegate! as! AppDelegate
            
            appDelegate.managedObjectContext.deleteObject(notification)
            
            try! appDelegate.managedObjectContext.save()
        }
    }
}