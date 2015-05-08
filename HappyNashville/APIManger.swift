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
    
    class func requestNewData(completed: (dealDays: Array<DealDay>) -> Void) {
        
        let urlString = "https://nameless-sea-7366.herokuapp.com/retrieve"
        var url: NSURL = NSURL(string: urlString)!;
        var request: NSURLRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60.0)
//        let reachability = Reachability.reachabilityForInternetConnection()
        
//        reachability.whenReachable = { reachability in
        
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
                
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
            
                self.updateDeals(jsonResult["locations"] as! NSArray, completed: { (dealDays) -> Void in
                    completed(dealDays: dealDays)
                })
        }

    }
    
    class func updateDeals(deals: NSArray, completed: (dealDays: Array<DealDay>) -> Void) {
        
        var locationArray: Array<Location> = []

        for location in deals as! [NSDictionary] {
            
            locationArray.append(createLocation(location))
            
        }
        
        completed(dealDays: self.masterDealDaysArray)
    }
    
    class func createLocation(locationDict: NSDictionary) -> Location {
        let location: Location = Location()
        
        for key in locationDict.allKeys as! [String] {
            
            if key == "dealDays" {
                
                location.addDealDays(self.addDealDays(locationDict[key] as! NSArray, location: location) as Set<NSObject>)
            } else if key == "_id" {
                
                println(locationDict[key])
            }else if key == "coords" {
                var coordsDict: NSDictionary = locationDict[key] as! NSDictionary
                location.lat = coordsDict["lat"] as! NSNumber
                location.lng = coordsDict["lng"] as! NSNumber
            } else {

                location.setValue(locationDict[key], forKey: key)
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
    
    class func updateOrAdd(locationDict: NSDictionary, moc: NSManagedObjectContext) {
        
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Location")
        
        fetchRequest.predicate =  NSPredicate(format: "name == %@", locationDict["name"] as! String)
        
        let result = moc.executeFetchRequest(fetchRequest, error: nil)
        
//        if result?.count > 0 {
//
//            for  location in result as [Location] {
//                
////                for deal in location.deals {
////                    
////                    moc.deleteObject(deal as NSManagedObject)
////                }
//                
//                location.deals = (self.setDeals(locationDict["deals"]! as NSArray,  moc: moc) as NSSet)
//                
//                
//                moc.save(nil)
//            }
//        } else {
//            
            createLocation(locationDict)
//        }

        
    }
    
    class func deleteAllDeals(moc: NSManagedObjectContext) {
    
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Location")
        
        if let result: NSArray = moc.executeFetchRequest(fetchRequest, error: nil) {
            
            for  location in result {
                
                moc.deleteObject(location as! NSManagedObject)
            }
        }
    }
    
    class func fetchAllDealDays(moc: NSManagedObjectContext) -> NSArray? {
    
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "DealDay")
        
        return moc.executeFetchRequest(fetchRequest, error: nil)
    }
    
    class func fetchAllLocations(moc: NSManagedObjectContext) -> NSArray? {
        
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Location")
        
        return moc.executeFetchRequest(fetchRequest, error: nil)
    }
    
    class func shouldUpdateData(version: NSNumber, moc: NSManagedObjectContext) -> Bool {
        
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "MetaData")
        
        let result: NSArray = moc.executeFetchRequest(fetchRequest, error: nil)!
        
        if  result.count > 0 {
            
            let metaData: MetaData = result[0] as! MetaData
            
            if metaData.version == version {
                
                return false
            } else {
                
                metaData.version = version
                
                moc.save(nil)
                
                return true
            }
        
        } else {
            
            let metaData: MetaData = NSEntityDescription.insertNewObjectForEntityForName("MetaData", inManagedObjectContext: moc) as! MetaData
            
            metaData.version = version
            
            moc.save(nil)
            
            return true
        }
    }
    
    class func fetchNotifications() -> NSArray? {
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Notification")
        
        return appDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
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

