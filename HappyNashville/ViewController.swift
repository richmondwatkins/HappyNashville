//
//  ViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 3/31/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ScheduleReminder, ViewModelProtocol, ScheduleProtocol {
    
    var viewModel: ViewControllerViewModel = ViewControllerViewModel()
    var tableView: UITableView = UITableView()
    var subView: UIView = UIView()
    let titleBottomPadding: CGFloat = 15
    let specialBottomPadding: CGFloat = 5
    let infoButtonsHeight: CGFloat = 40
    let infoButtonsTopPadding: CGFloat = 10
    let titleLabelHeight: CGFloat = 30
    let specialHeight: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.frame = self.view!.frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.subView.frame = self.view!.frame
        
        self.subView.addSubview(self.tableView)
        
        self.view!.addSubview(self.subView)
        self.view!.backgroundColor = UIColor.whiteColor()
        
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor(hexString: "DBDBDB")
        self.tableView.reloadData()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        
        self.viewModel.delegate = self
        
        if self.viewModel.tableSections.count - 1 > self.viewModel.getCurrentDay() {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: self.viewModel.getCurrentDay()), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        } else if (self.viewModel.tableSections.count > 0) {
             self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: self.viewModel.tableSections.count - 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
        var settingsButton : UIBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: "displayNotifications:")
        
        self.navigationItem.leftBarButtonItem = settingsButton
        
    }
    
    override func viewDidLayoutSubviews() {
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionDay: Int = self.viewModel.tableSections[section]
        
        return  self.viewModel.tableDataSource[sectionDay]!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.viewModel.tableSections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.viewModel.dayForDayNumber(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? LocationTableViewCell

        if cell == nil {
            
            cell = LocationTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        } else {
            
            clearCellSpecials(cell!)
        }
        
        configureCell(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return calculateCellHeight(indexPath)
    }
    
    func clearCellSpecials(cell: LocationTableViewCell) {
        for view in cell.contentCard.subviews {
            if view.tag == 1 || view.tag == 2 {
                view.removeFromSuperview()
            }
        }
    }
    
    func configureCell(cell: LocationTableViewCell, indexPath: NSIndexPath) {
        
        let deals = returnDealsArray(indexPath)
        
        var dealDay: DealDay = deals[indexPath.row] as! DealDay
        
        cell.titleLable.text = dealDay.location.name
        
        cell.delegate = self
        
        var top: CGFloat = cell.titleLable.bottom + self.titleBottomPadding
        
        for special in self.viewModel.sortSpecialsByTime(dealDay.specials) as! [Special] {
        
            let specialView: SpecialView = SpecialView(special: special, frame: CGRectMake(10, top, self.view!.width - 10, self.specialHeight))
            
            cell.contentCard.addSubview(specialView)

            specialView.top = top
            
            top = specialView.bottom + specialBottomPadding
            
            specialView.tag = 1
        }
        
        let infoButtonWidth: CGFloat = 100
        
        let cellHeight: CGFloat = calculateCellHeight(indexPath)
        
        cell.containerView.frame = CGRectMake(0, 0, self.view!.width * 0.95, cellHeight * 0.98)
        cell.containerView.center = CGPointMake(self.view!.width / 2, cellHeight / 2)
        
        cell.contentCard.frame = CGRectMake(0, 0, cell.containerView.width, cell.containerView.height - self.infoButtonsHeight)
        
        cell.buttonView.frame = CGRectMake(0, cell.contentCard.bottom, cell.containerView.width, self.infoButtonsHeight)
        
        let buttonViewHeight = cell.buttonView.height
        let buttonViewWidth = cell.buttonView.width
        
        let buttonMeasurements = self.viewModel.getButtonWidth(buttonViewWidth)
        
        cell.webSiteButton.frame = CGRectMake(0, 0, buttonMeasurements.buttonWidth, buttonViewHeight)
        cell.webSiteButton.addTarget(self, action: "webSiteButtonPressed:", forControlEvents: .TouchUpInside)
        
        cell.mapButton.frame = CGRectMake(cell.webSiteButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, buttonViewHeight)
        cell.mapButton.addTarget(self, action: "mapButtonPressed:", forControlEvents: .TouchUpInside)
        
        cell.scheduleButton.frame = CGRectMake(cell.mapButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, buttonViewHeight)
        
        if dealDay.notification == nil {
         
            cell.scheduleButton.setTitle("Schedule", forState: UIControlState.Normal)
            cell.scheduleButton.addTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
        } else {
            
            cell.scheduleButton.setTitle("Unschedule", forState: UIControlState.Normal)
            cell.scheduleButton.addTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
        }
        
        cell.titleLable.sizeToFit()
        let typeViewWidth: CGFloat = 20
        
        switch dealDay.type.integerValue {
            case 0:
                cell.typeView.layer.contents = UIImage(named: "alcohol")?.CGImage!
                cell.typeView.frame = CGRectMake(cell.contentCard.width - typeViewWidth - 5, cell.titleLable.top, typeViewWidth, 20);
                break;
            case 1:
                cell.typeView.layer.contents = UIImage(named: "food")?.CGImage!
                cell.typeView.frame = CGRectMake(cell.contentCard.width - typeViewWidth - 5, cell.titleLable.top, typeViewWidth, 20);
                break;
            case 2:
                cell.typeView.layer.contents = UIImage(named: "food")?.CGImage!
                cell.typeView.frame = CGRectMake(cell.contentCard.width - typeViewWidth - 5, cell.titleLable.top, typeViewWidth, 20);
                
                var secondTypeView: UIView = UIView()
                secondTypeView.layer.contents = UIImage(named: "alcohol")?.CGImage!
                secondTypeView.frame = CGRectMake(0, cell.titleLable.top, typeViewWidth, 20);
                secondTypeView.right = cell.typeView.left - 2;
                secondTypeView.tag = 2
                cell.contentCard.addSubview(secondTypeView)
                break;
            default:
                break;
        }
        
        let ratingViewWidth: CGFloat = 80
        cell.ratingView.frame = CGRectMake(cell.contentCard.width - ratingViewWidth, cell.typeView.bottom + 2, ratingViewWidth, titleBottomPadding)
     
        cell.ratingView.value = CGFloat(dealDay.location.rating.intValue)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let splitVC: UISplitViewController = appDelegate.window!.rootViewController as! UISplitViewController
        
        let dealDay: DealDay = getDealDayForIndexPath(indexPath)
        
        let detailViewController: DetailViewController = DetailViewController(location: dealDay.location)
        
        splitVC.showDetailViewController(detailViewController, sender: self)
        
    }
    
    func webSiteButtonPressed(sender: UIButton) {
        
        let deal: DealDay = returnSelectedDealDay(sender).dealDay
        
        let webViewController: LocationWebViewController = LocationWebViewController(location: deal.location, navBarHeight: self.navigationController!.navigationBar.height + UIApplication.sharedApplication().statusBarFrame.height)
        
        self.presentViewController(webViewController, animated: true, completion: nil)
    }

    func scheduleButtonPressed(sender: UIButton) {
        
        var scheduleViewController: ScheduleViewController = ScheduleViewController(dealDay: returnSelectedDealDay(sender).dealDay, navHeight: self.navigationController!.navigationBar.height + UIApplication.sharedApplication().statusBarFrame.height, indexPath: returnSelectedDealDay(sender).indexPath)
        scheduleViewController.delegate = self
        
        self.addChildViewController(scheduleViewController)
        
        self.subView.transformAndAddSubview(scheduleViewController.view)
        
        scheduleViewController.didMoveToParentViewController(self)
    }
    
    func mapButtonPressed(sender: UIButton) {
        
        let dealDay: DealDay = returnSelectedDealDay(sender).dealDay
        
        let mapViewController: MapViewController = MapViewController(location: dealDay.location)
        
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func unscheduleNotification(sender: UIButton) {
        
        let indexPath: NSIndexPath = indexPathForSelectedRow(sender)
        
        self.viewModel.unscheduleNotification(returnSelectedDealDay(sender).dealDay)
        
        var cell: LocationTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! LocationTableViewCell
        
        cell.scheduleButton.setTitle("Schedule", forState: UIControlState.Normal)
        cell.scheduleButton.removeTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
        cell.scheduleButton.addTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
    }
    
    func updateScheduledCell(indexPath: NSIndexPath) {
        
        var cell: LocationTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! LocationTableViewCell
        
        cell.scheduleButton.setTitle("UnSchedule", forState: .Normal)
        cell.scheduleButton.removeTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
        cell.scheduleButton.addTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
    }
    
    func returnSelectedDealDay(selectedButton: UIButton) -> (dealDay: DealDay, indexPath: NSIndexPath) {
        
        let indexPath: NSIndexPath = indexPathForSelectedRow(selectedButton)
        
        return (getDealDayForIndexPath(indexPath), indexPath)
    }
    
    func getDealDayForIndexPath(indexPath: NSIndexPath) -> DealDay {
        
        let dataSourceKey: Int = self.viewModel.tableSections[indexPath.section]
        
        let dealDays = self.viewModel.tableDataSource[dataSourceKey]!
        
        return dealDays[indexPath.row]
    }
    
    func displayNotifications(sender: UIButton) {
        
        var notificationViewController: NotificationsManagerViewController = NotificationsManagerViewController()
        
        self.presentViewController(notificationViewController, animated: true, completion: nil)
    }
    
    func indexPathForSelectedRow(selectedButton: UIButton) -> NSIndexPath {
        
        let buttonPostion: CGPoint = selectedButton.convertPoint(CGPointZero, toView: self.tableView)
        
        return self.tableView.indexPathForRowAtPoint(buttonPostion)!
    }
    
    func returnDealsArray(indexPath: NSIndexPath) -> NSArray {
        
        let dataSourceKey: Int = self.viewModel.tableSections[indexPath.section]
        
        return self.viewModel.tableDataSource[dataSourceKey]!
    }
    
    
    func calculateCellHeight(indexPath: NSIndexPath) -> CGFloat {
        
        let deals = returnDealsArray(indexPath)
        
        let specials = deals[indexPath.row].specials as NSSet
       
        var cellHeight: CGFloat = self.titleLabelHeight + self.titleBottomPadding + self.infoButtonsHeight + self.infoButtonsTopPadding + (self.specialBottomPadding * CGFloat(specials.count)) + (self.specialHeight * CGFloat(specials.count))
        
        
        return cellHeight
    }
    
    func reloadTable() {
        
        self.tableView.reloadData()
    }
    
}

