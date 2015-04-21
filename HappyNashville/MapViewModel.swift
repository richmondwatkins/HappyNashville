//
//  MapViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/20/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class MapViewModel: NSObject {
    
    var locations: Array<Location> = []
    
    override init() {
        super.init()
        
        fetchData()
    }
   
    func fetchData() {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let fetchResult = APIManger.fetchAllLocations(appDelegate.managedObjectContext!) {
            
            self.locations = fetchResult.mutableCopy() as AnyObject as! [Location]
        }
    }
    
}
