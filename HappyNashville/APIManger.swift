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
    
    
    
    class func requestNewData(moc: NSManagedObjectContext) {
        
        let urlString = "https://s3-us-west-2.amazonaws.com/nashvilledeals/deals.json"
        var url: NSURL = NSURL(string: urlString)!;
        var request: NSURLRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in

            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
            if self.shouldUpdateData(jsonResult["version"] as NSNumber, moc: moc) {
                
                 self.updateDeals(jsonResult["locations"] as NSArray, moc: moc);
            }
        }
        
    }
    
    class func updateDeals(deals: NSArray, moc: NSManagedObjectContext) {
        
        for location in deals as [NSDictionary] {
            
            updateOrAdd(location, moc: moc)
            
        }
        
        moc.save(nil)
        
    }
    
    class func createLocation(locationDict: NSDictionary, moc: NSManagedObjectContext) {
        let location: Location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: moc) as Location;
        
        for key in locationDict.allKeys as [String] {
            
            if key == "deal" {
                
                location.deal = self.addDeal(locationDict[key] as NSDictionary, moc: moc)
            } else {
                
                location.setValue(locationDict[key], forKey: key)
            }
        }
    }
    
    class func addDeal(dealDict: NSDictionary, moc: NSManagedObjectContext) -> Deal {
        
         var deal: Deal = NSEntityDescription.insertNewObjectForEntityForName("Deal", inManagedObjectContext: moc) as Deal
        
        for  dealAttr in dealDict.allKeys as [String] {
            
            if dealAttr == "specials" {
                
                deal.addSpecials(self.setSpecials(dealDict["specials"] as NSArray, moc: moc))
            } else {
                
                deal.setValue(dealDict[dealAttr], forKey: dealAttr)
            }
            
        }
        
        return deal
    }
    
    class func setSpecials(specials: NSArray, moc: NSManagedObjectContext) -> NSSet {
        
        var specialMutable: NSMutableArray = NSMutableArray()
        
        for  specialDict in specials as [NSDictionary] {
            
            var special: Special = NSEntityDescription.insertNewObjectForEntityForName("Special", inManagedObjectContext: moc) as Special
            
            for key in specialDict.allKeys as [String] {
    
                special.setValue(specialDict[key], forKey: key)
            }
            
            specialMutable.addObject(special)
        }
        
        return NSSet().setByAddingObjectsFromArray(specialMutable)
    }
    
    class func updateOrAdd(locationDict: NSDictionary, moc: NSManagedObjectContext) {
        
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Location")
        
        fetchRequest.predicate =  NSPredicate(format: "name == %@", locationDict["name"] as String)
        
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
            createLocation(locationDict, moc: moc)
//        }

        
    }
    
    class func deleteAllDeals(moc: NSManagedObjectContext) {
    
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Location")
        
        if let result: NSArray = moc.executeFetchRequest(fetchRequest, error: nil)? {
            
            for  location in result {
                
                moc.deleteObject(location as NSManagedObject)
            }
        }
    }
    
    class func fetchAllDeals(moc: NSManagedObjectContext) -> NSArray? {
    
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Deal")
        
        return moc.executeFetchRequest(fetchRequest, error: nil)
    }
    
    class func shouldUpdateData(version: NSNumber, moc: NSManagedObjectContext) -> Bool {
        
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "MetaData")
        
        let result: NSArray = moc.executeFetchRequest(fetchRequest, error: nil)!
        
        if  result.count > 0 {
            
            let metaData: MetaData = result[0] as MetaData
            
            if metaData.version == version {
                
                return false
            } else {
                
                metaData.version = version
                
                moc.save(nil)
                
                return true
            }
        
        } else {
            
            let metaData: MetaData = NSEntityDescription.insertNewObjectForEntityForName("MetaData", inManagedObjectContext: moc) as MetaData
            
            metaData.version = version
            
            moc.save(nil)
            
            return true
        }
    }
    
}

