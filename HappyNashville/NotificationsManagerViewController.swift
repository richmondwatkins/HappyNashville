//
//  NotificationsManagerViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/15/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

@objc protocol SettingsProtocl {
    func reloadTable()
}

class NotificationsManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    var viewModel: NotificationViewModel = NotificationViewModel()
    var navBarHeight: CGFloat = 0
    var delegate: SettingsProtocl?
    
    init(navBarHeight: CGFloat) {
        self.navBarHeight = navBarHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navBar: UIView = UIView(frame: CGRectMake(0, 0, self.view!.width, self.navBarHeight + 20))
        
        navBar.backgroundColor = UIColor(hexString: "F8F8F8")
        
        
        var titleLabel: UILabel = UILabel();
        titleLabel.text = "Settings"
        titleLabel.sizeToFit();
        
        navBar.addSubview(titleLabel)
        titleLabel.center = navBar.center
        
        var backButton: UIButton = UIButton()
        
        backButton.setTitle("Back", forState: .Normal)
        backButton.sizeToFit()
        
        backButton.frame = CGRectMake(navBar.width - backButton.width - 4, navBar.height / 2 - backButton.height / 2, backButton.width, backButton.height)
        backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        backButton.addTarget(self, action: "closeVC", forControlEvents: .TouchUpInside)
        
        navBar.addSubview(backButton)
        
        self.view!.addSubview(navBar)
        
        self.tableView.frame = CGRectMake(0, navBar.bottom, self.view!.width, self.view!.height - navBar.height)
        
        self.view!.addSubview(self.tableView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELLY")
        
        self.tableView.reloadData()
    }
    
    func closeVC() {
        self.dismissViewControllerAnimated(true, completion: {});
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
                
                dispatch_async(dispatch_get_main_queue(),{
                   self.delegate?.reloadTable()
                })
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
        
        cell.detailTextLabel!.text = configureDateString(notification)
    }
    
    func configureDateString(notification: Notification) -> String {

        var dayOfWeek: NSDateFormatter = NSDateFormatter()
        dayOfWeek.dateFormat = "EEEE"
        
        var time: NSDateFormatter = NSDateFormatter()
        time.dateFormat = "h:mm"
        
        if notification.isRecurring.boolValue {
            return "Weekly on \(dayOfWeek.stringFromDate(notification.date)) at \(time.stringFromDate(notification.date))"
        } else {
            return "Once on \(dayOfWeek.stringFromDate(notification.date)) at \(time.stringFromDate(notification.date))"
        }
    }
}
