//
//  NotificationsManagerViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/15/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class NotificationsManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    var viewModel: NotificationViewModel = NotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.frame = self.view!.frame
        
        self.view!.addSubview(self.tableView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
        
            let notification: Notification = self.viewModel.tableDataSource[indexPath.row] as! Notification
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { ()->() in
                
                APIManger.deleteNotification(notification)
            })
            
            self.viewModel.tableDataSource.removeObjectAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? LocationTableViewCell
        
        if cell == nil {
            
            cell = LocationTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        configureCell(cell!, indexPath: indexPath)
        
        return cell!
    }

    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        var notification: Notification = self.viewModel.tableDataSource[indexPath.row] as! Notification
        
        cell.textLabel?.text = notification.text
    }
}
