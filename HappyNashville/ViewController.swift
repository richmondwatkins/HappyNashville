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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ScheduleReminder, ViewModelProtocol {
    
    var viewModel: ViewControllerViewModel = ViewControllerViewModel()
    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.frame = self.view!.frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view!.addSubview(self.tableView)
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
        return 150
    }
    
    func configureCell(cell: LocationTableViewCell, indexPath: NSIndexPath) {
                
        let dataSourceKey: String = self.viewModel.tableSections![indexPath.section] as String
        
        let deals = self.viewModel.tableDataSource[dataSourceKey] as NSArray
        
        var deal: Deal = deals[indexPath.row] as Deal
        
        cell.titleLable.text = deal.location.name
        
        cell.delegate = self
        
        var top: CGFloat = cell.titleLable.bottom + 5
        
        for special in deal.specials.allObjects as [Special] {
            
            var specialLabel: UILabel = UILabel(frame: CGRectMake(10, 0, 0, 0))
            specialLabel.text = special.specialDescription
            specialLabel.sizeToFit()
            cell.addSubview(specialLabel)
            
            specialLabel.top = top
            
            top = specialLabel.bottom + 2
        }
        
        cell.textLabel!.text = deal.specials.allObjects[0].specialDescription
    }
    
    func animateImageTransition(cell: LocationTableViewCell) {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let splitVC: UISplitViewController = appDelegate.window.rootViewController as UISplitViewController
        let detailViewController: DetailViewController = DetailViewController()
        
        splitVC.showDetailViewController(detailViewController, sender: self)
        
    }

    func scheduleButtonPressed(sender: UIButton) {
        
        let buttonPostion: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)

        if let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(buttonPostion) {
            
            var navHeight: CGFloat = self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
            
            let scheduleFrame: CGRect = CGRectMake(0, navHeight, self.view!.width, self.view!.height)
            
            let dataSourceKey: String = self.viewModel.tableSections![indexPath.section] as String
            
            let deals = self.viewModel.tableDataSource[dataSourceKey] as NSArray
            
            var scheduleViewController: ScheduleViewController = ScheduleViewController(deal: deals[indexPath.row] as Deal)
            
            self.addChildViewController(scheduleViewController)
            
            self.view!.addSubview(scheduleViewController.view)
            
            scheduleViewController.didMoveToParentViewController(self)

        }
    }
    
    func reloadTable() {
        
        self.tableView.reloadData()
    }
    
}

