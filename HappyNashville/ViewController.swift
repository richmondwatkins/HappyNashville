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
    let titleBottomPadding: CGFloat = 10
    let specialBottomPadding: CGFloat = 5
    let infoButtonsHeight: CGFloat = 30
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
    }
    
    override func viewDidLayoutSubviews() {
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionTitle: String = self.viewModel.tableSections[section]
        
        let deals = self.viewModel.tableDataSource[sectionTitle] as! NSArray
        
        return deals.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.viewModel.tableSections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.viewModel.tableSections[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? LocationTableViewCell

        if cell == nil {
            
            cell = LocationTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        configureCell(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return calculateCellHeight(indexPath)
    }
    
    func configureCell(cell: LocationTableViewCell, indexPath: NSIndexPath) {
        
        let deals = returnDealsArray(indexPath)
        
        var deal: DealDay = deals[indexPath.row] as! DealDay
        
        cell.titleLable.text = deal.location.name
        
        cell.delegate = self
        
        var top: CGFloat = cell.titleLable.bottom + self.titleBottomPadding
        
        for special in self.viewModel.sortSpecialsByTime(deal.specials) as! [Special] {
        
            let specialView: SpecialView = SpecialView(special: special, frame: CGRectMake(10, top, self.view!.width - 10, self.specialHeight))
            
            cell.contentCard.addSubview(specialView)

            specialView.top = top
            
            top = specialView.bottom + specialBottomPadding
        }
        
        let infoButtonWidth: CGFloat = 100
        
        let cellHeight: CGFloat = calculateCellHeight(indexPath)
        
        cell.contentCard.frame = CGRectMake(0, 0, self.view!.width * 0.95, cellHeight * 0.9)
        
        cell.contentCard.center = CGPointMake(self.view!.width / 2, cellHeight / 2)
        
        let cardHeight = cell.contentCard.height
        let cardWidth = cell.contentCard.width
        
        cell.scheduleButton.frame = CGRectMake(cardWidth - infoButtonWidth, cardHeight - self.infoButtonsHeight, infoButtonWidth, self.infoButtonsHeight)
        
        if deal.notification == nil {
         
            cell.scheduleButton.setTitle("Schedule", forState: UIControlState.Normal)
            cell.scheduleButton.addTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
        } else {
            
            cell.scheduleButton.setTitle("Unschedule", forState: UIControlState.Normal)
            cell.scheduleButton.addTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
        }
        
        cell.webSiteButton.frame = CGRectMake(0, cardHeight - self.infoButtonsHeight, infoButtonWidth, self.infoButtonsHeight)
        cell.webSiteButton.addTarget(self, action: "webSiteButtonPressed:", forControlEvents: .TouchUpInside)
        
        cell.titleLable.sizeToFit()
        
        switch deal.type.integerValue {
            case 0:
                cell.typeView.layer.contents = UIImage(named: "alcohol")?.CGImage!
                cell.typeView.frame = CGRectMake(0, cell.titleLable.top, 20, 20);
                cell.typeView.left = cell.titleLable.right + 5;
                break;
            case 1:
                cell.typeView.layer.contents = UIImage(named: "food")?.CGImage!
                cell.typeView.frame = CGRectMake(0, cell.titleLable.top, 20, 20);
                cell.typeView.left = cell.titleLable.right + 5;
                break;
            case 2:
                cell.typeView.layer.contents = UIImage(named: "food")?.CGImage!
                cell.typeView.frame = CGRectMake(0, cell.titleLable.top, 20, 20);
                cell.typeView.left = cell.titleLable.right + 5;
                
                var secondTypeView: UIView = UIView()
                secondTypeView.layer.contents = UIImage(named: "alcohol")?.CGImage!
                secondTypeView.frame = CGRectMake(0, cell.titleLable.top, 20, 20);
                secondTypeView.left = cell.typeView.right + 2;
                cell.contentCard.addSubview(secondTypeView)
                break;
            default:
                break;
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let splitVC: UISplitViewController = appDelegate.window!.rootViewController as! UISplitViewController
        let detailViewController: DetailViewController = DetailViewController()
        
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
        
        let dataSourceKey: String = self.viewModel.tableSections[indexPath.section]
        
        let deals = self.viewModel.tableDataSource[dataSourceKey]!
        
        return (deals[indexPath.row], indexPath)
    }
    
    func indexPathForSelectedRow(selectedButton: UIButton) -> NSIndexPath {
        
        let buttonPostion: CGPoint = selectedButton.convertPoint(CGPointZero, toView: self.tableView)
        
        return self.tableView.indexPathForRowAtPoint(buttonPostion)!
    }
    
    func returnDealsArray(indexPath: NSIndexPath) -> NSArray {
        
        let dataSourceKey: String = self.viewModel.tableSections[indexPath.section]
        
        return self.viewModel.tableDataSource[dataSourceKey]!
    }
    
    
    func calculateCellHeight(indexPath: NSIndexPath) -> CGFloat {
        
        let deals = returnDealsArray(indexPath)
        
        let specials = deals[indexPath.row].specials as NSSet
       
        var cellHeight: CGFloat = self.titleLabelHeight + self.titleBottomPadding + self.infoButtonsHeight + self.infoButtonsTopPadding + (self.specialBottomPadding * CGFloat(specials.count)) + (self.specialHeight * CGFloat(specials.count))
        
        let contentCardOffset: CGFloat = 20
        
        return cellHeight + contentCardOffset
    }
    
    func reloadTable() {
        
        self.tableView.reloadData()
    }
    
}

