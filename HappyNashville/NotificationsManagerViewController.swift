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
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELLY")
        
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
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CELLY") as? UITableViewCell
        
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "CELLY")
        }

        configureCell(cell! , indexPath: indexPath)
        
        
        return cell!
    }

    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        var notification: Notification = self.viewModel.tableDataSource[indexPath.row] as! Notification
        
        cell.textLabel?.text = notification.text
        
        cell.detailTextLabel!.text = configureDateString(notification.date)
    }
    
    func configureDateString(date: NSDate) -> String {

        var dayOfWeek: NSDateFormatter = NSDateFormatter()
        dayOfWeek.dateFormat = "EEEE"
        
        var time: NSDateFormatter = NSDateFormatter()
        time.dateFormat = "h:mm"

        
        return "Notifies you on \(dayOfWeek.stringFromDate(date)) at \(time.stringFromDate(date))"
    }
}
