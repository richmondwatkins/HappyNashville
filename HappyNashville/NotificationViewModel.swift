//
//  NotificationViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/15/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class NotificationViewModel: NSObject {
   
    var tableDataSource: NSMutableArray = []
    
    override init() {
        super.init()
        
        if let notifications: NSArray = APIManger.fetchNotifications() {
            self.tableDataSource = notifications.mutableCopy() as! NSMutableArray
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return self.tableDataSource.count
    }

}
