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
        
        self.tableView.reloadData()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        
        self.viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionTitle: String = self.viewModel.tableSections![section] as String
        
        let deals = self.viewModel.tableDataSource[sectionTitle] as NSArray
        
        return deals.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.viewModel.tableSections!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.viewModel.tableSections![section] as? String
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
        
        let deals = returnDealsArray(indexPath)
        
        let specials = deals[indexPath.row].specials as NSSet
        let cellHeight: CGFloat = self.titleLabelHeight + self.titleBottomPadding + self.infoButtonsHeight + self.infoButtonsTopPadding + (self.specialBottomPadding * CGFloat(specials.count)) + (self.specialHeight * CGFloat(specials.count))
        
        return cellHeight

    }
    
    func configureCell(cell: LocationTableViewCell, indexPath: NSIndexPath) {
        
        let deals = returnDealsArray(indexPath)
        
        var deal: Deal = deals[indexPath.row] as Deal
        
        cell.titleLable.text = deal.location.name
        
        cell.delegate = self
        
        var top: CGFloat = cell.titleLable.bottom + self.titleBottomPadding
        
        for special in self.viewModel.sortSpecialsByTime(deal.specials) as [Special] {
        
            let specialView: SpecialView = SpecialView(special: special, frame: CGRectMake(10, top, self.view!.width - 10, self.specialHeight))
            
            cell.addSubview(specialView)

            specialView.top = top
            
            top = specialView.bottom + specialBottomPadding
        }
        
        let infoButtonWidth: CGFloat = 100
        
        let cellHeight: CGFloat = calculateCellHeight(indexPath)
        
        var scheduleButton: UIButton = UIButton(frame: CGRectMake(self.view!.width - infoButtonWidth, cellHeight - self.infoButtonsHeight, infoButtonWidth, self.infoButtonsHeight));
        scheduleButton.backgroundColor = UIColor.redColor()
        
        if deal.notification == nil {
         
            scheduleButton.setTitle("Schedule", forState: UIControlState.Normal)
            scheduleButton.addTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
        } else {
            
            scheduleButton.setTitle("Unschedule", forState: UIControlState.Normal)
            scheduleButton.addTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
        }
        
        var webSiteButton: UIButton = UIButton(frame: CGRectMake(0, cellHeight - self.infoButtonsHeight, infoButtonWidth, self.infoButtonsHeight))
        webSiteButton.backgroundColor = UIColor.blueColor()
        webSiteButton.addTarget(self, action: "webSiteButtonPressed:", forControlEvents: .TouchUpInside)
        webSiteButton.setTitle("Website", forState: UIControlState.Normal)
        
        cell.addSubview(webSiteButton)
        cell.addSubview(scheduleButton)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let splitVC: UISplitViewController = appDelegate.window.rootViewController as UISplitViewController
        let detailViewController: DetailViewController = DetailViewController()
        
        splitVC.showDetailViewController(detailViewController, sender: self)
        
    }
    
    func webSiteButtonPressed(sender: UIButton) {
        
        let deal: Deal = returnSelectedDeal(sender).deal
        
        let webViewController: LocationWebViewController = LocationWebViewController(url: NSURL(string: deal.location.website)!, navBarHeight: self.navigationController!.navigationBar.height + UIApplication.sharedApplication().statusBarFrame.height)
        
        self.presentViewController(webViewController, animated: true, completion: nil)
    }

    func scheduleButtonPressed(sender: UIButton) {
        
        var scheduleViewController: ScheduleViewController = ScheduleViewController(deal:returnSelectedDeal(sender).deal, navHeight: self.navigationController!.navigationBar.height + UIApplication.sharedApplication().statusBarFrame.height, indexPath: returnSelectedDeal(sender).indexPath)
        scheduleViewController.delegate = self
        
        self.addChildViewController(scheduleViewController)
        
        self.subView.transformAndAddSubview(scheduleViewController.view)
        
        scheduleViewController.didMoveToParentViewController(self)
            
    }
    
    func unscheduleNotification(sender: UIButton) {
        
        let indexPath: NSIndexPath = indexPathForSelectedRow(sender)
        
        self.viewModel.unscheduleNotification(returnSelectedDeal(sender).deal)
        
        var cell: LocationTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as LocationTableViewCell
        
        configureCell(cell, indexPath: indexPath)
    }
    
    func returnSelectedDeal(selectedButton: UIButton) -> (deal: Deal, indexPath: NSIndexPath) {
        
        let indexPath: NSIndexPath = indexPathForSelectedRow(selectedButton)
        
        let dataSourceKey: String = self.viewModel.tableSections![indexPath.section] as String
        
        let deals = self.viewModel.tableDataSource[dataSourceKey] as NSArray
        
        return (deals[indexPath.row] as Deal, indexPath)
    }
    
    func indexPathForSelectedRow(selectedButton: UIButton) -> NSIndexPath {
        
        let buttonPostion: CGPoint = selectedButton.convertPoint(CGPointZero, toView: self.tableView)
        
        return self.tableView.indexPathForRowAtPoint(buttonPostion)!
    }
    
    func returnDealsArray(indexPath: NSIndexPath) -> NSArray {
        
        let dataSourceKey: String = self.viewModel.tableSections![indexPath.section] as String
        
        return self.viewModel.tableDataSource[dataSourceKey] as NSArray
    }
    
    
    func calculateCellHeight(indexPath: NSIndexPath) -> CGFloat {
        
        let deals = returnDealsArray(indexPath)
        
        let specials = deals[indexPath.row].specials as NSSet
        var cellHeight: CGFloat = self.titleLabelHeight + self.titleBottomPadding + self.infoButtonsHeight + self.infoButtonsTopPadding + (self.specialBottomPadding * CGFloat(specials.count)) + (self.specialHeight * CGFloat(specials.count))
        
        return cellHeight
    }
    
    func updateScheduledCell(indexPath: NSIndexPath) {
        
        var cell: LocationTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as LocationTableViewCell
        
        configureCell(cell, indexPath: indexPath)
    }
    
    func reloadTable() {
        
        self.tableView.reloadData()
    }
    
}

