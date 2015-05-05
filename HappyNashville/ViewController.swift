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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewModelProtocol, ScheduleProtocol, SortProtocol, LocationCellProtocol {
    
    var viewModel: ViewControllerViewModel = ViewControllerViewModel()
    var tableView: UITableView = UITableView()
    var vcWithOutHeaders: ViewControllerWithoutHeadersViewController!
    var foodDrinkVC: FoodDrinkViewController!
    var subView: UIView = UIView()
    var customTitleView: UILabel = UILabel()
    var customTitleViewBorder: CALayer = CALayer()
    var sortIsDisplaying: Bool = Bool()
    
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
        self.tableView.backgroundColor = UIColor(hexString: StringConstants.grayShade)
        self.tableView.reloadData()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        
        self.viewModel.delegate = self
        
        if self.viewModel.tableSections.count - 1 > self.viewModel.getCurrentDay() {
            scrollToCurrentDay()
        } else if (self.viewModel.tableSections.count > 0) {
             self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
        var settingsButton: UIBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: "displayNotifications:")
        settingsButton.tintColor = .whiteColor()
        
        self.navigationItem.leftBarButtonItem = settingsButton
        
        var sortButton : UIBarButtonItem = UIBarButtonItem(title: "Sort", style: UIBarButtonItemStyle.Plain, target: self, action: "displaySortOptions:")
        sortButton.tintColor = .whiteColor()
        self.navigationItem.rightBarButtonItem = sortButton
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: StringConstants.primaryColor)
        
        self.customTitleView.backgroundColor = .clearColor()
        self.customTitleView.textColor = UIColor(hexString: StringConstants.navBarTextColor)
        self.customTitleView.textAlignment = .Center
        
        self.navigationItem.titleView = self.customTitleView
        
        self.customTitleView.layer.addSublayer(self.customTitleViewBorder)
        
    }
    
    func scrollToCurrentDay() {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: self.viewModel.getCurrentDay() - 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
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
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view: UIView = UIView(frame: CGRectMake(0, 0, self.view!.width, 20))
//        
//        view.backgroundColor = .clearColor()
//        
//        return view
//    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionDay: Int = self.viewModel.tableSections[section]
        
        if self.viewModel.tableDataSource[sectionDay]!.count > 0 {
            return self.viewModel.dayForDayNumber(self.viewModel.tableSections[section])
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? LocationTableViewCell

        if cell == nil {
            
            cell = LocationTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        configureCell(cell!, dealDay: returnDealsArray(indexPath)[indexPath.row])
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        var dealDay: DealDay = getDealDayForIndexPath(indexPath)!
        
        if dealDay.isOpen.boolValue {
            return CGFloat(dealDay.height.integerValue) + 40
        } else {
            return CGFloat(dealDay.height.integerValue)
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let locCell: LocationTableViewCell = cell as! LocationTableViewCell
        
        for view in locCell.contentCard.subviews {
            if view.tag == 1 || view.tag == 2 {
                view.removeFromSuperview()
            }
        }

        if let dealDay = getDealDayForIndexPath(indexPath) {
            locCell.discloseButton.setImage(UIImage(named: "disclose"), forState: .Normal)
            dealDay.isOpen = NSNumber(bool: false)
        }
    }
    
    func addSpecialsToCell(cell: LocationTableViewCell, dealDay: DealDay) {
        var top: CGFloat = cell.ratingView.bottom + 5
        
        for special in self.viewModel.sortSpecialsByTime(dealDay.specials) as! [Special] {
            
            let specialView: SpecialView = SpecialView(special: special, frame: CGRectMake(10, top, self.view!.width - 30, self.specialHeight))
            
            cell.contentCard.addSubview(specialView)
            
            specialView.top = top
            
            top = specialView.bottom + specialBottomPadding
            
            specialView.tag = 1
        }
    }
    
    func configureCell(cell: LocationTableViewCell, dealDay: DealDay) {
        
        cell.titleLable.text = dealDay.location.name
        
        cell.delegate = self
        
        cell.titleLable.sizeToFit()
        cell.titleLable.width = cell.width - 30
        
        let ratingViewWidth: CGFloat = 80
        cell.ratingView.frame = CGRectMake(10, cell.titleLable.bottom + 2, ratingViewWidth, titleBottomPadding)
        
        cell.ratingView.value = CGFloat(dealDay.location.rating.intValue)
        
        addSpecialsToCell(cell, dealDay: dealDay)
        
        let infoButtonWidth: CGFloat = 100
        
        let cellHeight: CGFloat = getCellHeight(dealDay)
        
        cell.containerView.frame = CGRectMake(0, 0, self.view!.width * 0.95, cellHeight * 0.95)
        cell.containerView.center = CGPointMake(self.view!.width / 2, cellHeight / 2)
        
        cell.contentCard.frame = CGRectMake(0, 0, cell.containerView.width, cell.containerView.height)
        
        cell.buttonView.frame = CGRectMake(0, cell.contentCard.bottom, cell.containerView.width, 0)
        
        cell.discloseButton.frame = CGRectMake(cell.contentCard.width - cell.discloseButton.width, cell.contentCard.height - cell.discloseButton.height + 10, cell.discloseButton.width, cell.discloseButton.height)
        cell.contentCard.bringSubviewToFront(cell.discloseButton)
        cell.discloseButton.addTarget(self, action: "expandInfoCell:", forControlEvents: .TouchUpInside)
        
        let buttonViewHeight = cell.buttonView.height
        let buttonViewWidth = cell.buttonView.width
        
        let buttonMeasurements = self.viewModel.getButtonWidth(buttonViewWidth, numberOfButtons: CGFloat(3), padding: 1)
        
        cell.webSiteButton.frame = CGRectMake(0, 0, buttonMeasurements.buttonWidth, buttonViewHeight)
        cell.webSiteButton.addTarget(self, action: "webSiteButtonPressed:", forControlEvents: .TouchUpInside)
        
        cell.mapButton.frame = CGRectMake(cell.webSiteButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, buttonViewHeight)
        cell.mapButton.addTarget(self, action: "mapButtonPressed:", forControlEvents: .TouchUpInside)
        
        cell.scheduleButton.frame = CGRectMake(cell.mapButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, buttonViewHeight)

        cell.scheduleButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        
        if dealDay.notification == nil {
         
            cell.scheduleButton.setImage(UIImage(named: "schedule"), forState: .Normal)
            cell.scheduleButton.addTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
        } else {
            cell.scheduleButton.setImage(UIImage(named: "schedule-cal-white"), forState: .Normal)
            cell.scheduleButton.addTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
        }
        
//        let typeViewWidth: CGFloat = 20
//        
//        switch dealDay.type.integerValue {
//            case 0:
//                cell.typeView.layer.contents = UIImage(named: "alcohol")?.CGImage!
//                cell.typeView.frame = CGRectMake(cell.contentCard.width - typeViewWidth - 5, cell.titleLable.top, typeViewWidth, 20);
//                break;
//            case 1:
//                cell.typeView.layer.contents = UIImage(named: "food")?.CGImage!
//                cell.typeView.frame = CGRectMake(cell.contentCard.width - typeViewWidth - 5, cell.titleLable.top, typeViewWidth, 20);
//                break;
//            case 2:
//                cell.typeView.layer.contents = UIImage(named: "food")?.CGImage!
//                cell.typeView.frame = CGRectMake(cell.contentCard.width - typeViewWidth - 5, cell.titleLable.top, typeViewWidth, 20);
//                
//                var secondTypeView: UIView = UIView()
//                secondTypeView.layer.contents = UIImage(named: "alcohol")?.CGImage!
//                secondTypeView.frame = CGRectMake(0, cell.titleLable.top, typeViewWidth, 20);
//                secondTypeView.right = cell.typeView.left - 2;
//                secondTypeView.tag = 2
//                cell.contentCard.addSubview(secondTypeView)
//                break;
//            default:
//                break;
//        }
        
    }
    
    func getCellHeight(dealDay: DealDay) -> CGFloat {
        
        return self.viewModel.calculateCellHeight(dealDay, specialCount: dealDay.specials.count)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let splitVC: UISplitViewController = appDelegate.window!.rootViewController as! UISplitViewController
        
        if let dealDay = getDealDayForIndexPath(indexPath) {
            let detailViewController: DetailViewController = DetailViewController(location: dealDay.location)
            
            splitVC.showDetailViewController(detailViewController, sender: self)
            
            var barButtonItem:UIBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
            
            barButtonItem.tintColor = .whiteColor()
            
            self.navigationItem.backBarButtonItem = barButtonItem
        }
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
        
        self.navigationItem.rightBarButtonItem!.title = ""
    }
    
    func mapButtonPressed(sender: UIButton) {
        
        let dealDay: DealDay = returnSelectedDealDay(sender).dealDay
        
        let mapViewController: MapViewController = MapViewController(location: dealDay.location)
        
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func unscheduleNotification(sender: UIButton) {
        
        let indexPath: NSIndexPath = indexPathForSelectedRow(sender)
        
        let dealDay = returnSelectedDealDay(sender).dealDay
        dealDay.notification = nil
        self.viewModel.unscheduleNotification(dealDay)
        
        var cell: LocationTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! LocationTableViewCell
        
        cell.scheduleButton.setImage(UIImage(named: "schedule"), forState: .Normal)
        cell.scheduleButton.removeTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
        cell.scheduleButton.addTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
    }
    
    func updateScheduledCell(indexPath: NSIndexPath) {
        
        var cell: LocationTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! LocationTableViewCell
        
        cell.scheduleButton.setImage(UIImage(named: "schedule-cal-white"), forState: .Normal)
        cell.scheduleButton.removeTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
        cell.scheduleButton.addTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
    }
    
    func returnSelectedDealDay(selectedButton: UIButton) -> (dealDay: DealDay, indexPath: NSIndexPath) {
        
        let indexPath: NSIndexPath = indexPathForSelectedRow(selectedButton)
        
        return (getDealDayForIndexPath(indexPath)!, indexPath)
    }
    
    func getDealDayForIndexPath(indexPath: NSIndexPath) -> DealDay? {
        
        let dataSourceKey: Int = self.viewModel.tableSections[indexPath.section]
        
        let dealDays = self.viewModel.tableDataSource[dataSourceKey]!
        
        if dealDays.count - 1 >= indexPath.row {
            return dealDays[indexPath.row]
        } else {
            return nil
        }
    }
    
    func displayNotifications(sender: UIButton) {
        
        var notificationViewController: NotificationsManagerViewController = NotificationsManagerViewController()
        
        self.presentViewController(notificationViewController, animated: true, completion: nil)
    }
    
    func displaySortOptions(sender: UIButton) {
        
        var sortViewController: SortViewController = SortViewController(sortTitle: self.customTitleView.text)
        
        sortViewController.delegate = self
        
        self.addChildViewController(sortViewController)
        
        self.view!.addSubview(sortViewController.view)
        
        sortViewController.didMoveToParentViewController(self)
    }
    
    func resetSort(navTitle: String) {
        self.customTitleView.text = navTitle
        self.customTitleView.sizeToFit()
        
        self.customTitleViewBorder.frame = CGRectZero
        self.customTitleViewBorder.backgroundColor = UIColor.clearColor().CGColor
        
        checkAndRemoveChildVCs()
        self.viewModel.resetSort()
        self.tableView.reloadData()
    }
    
    func showFoodOnly(navTitle: String) {
        self.customTitleView.text = navTitle
        self.customTitleView.textAlignment = .Center
        self.customTitleView.sizeToFit()
        
        self.customTitleViewBorder.frame = CGRectMake(0, self.customTitleView.height,customTitleView.width, 1);
        self.customTitleViewBorder.backgroundColor = UIColor(hexString: StringConstants.navBarTextColor).CGColor
        
        checkAndRemoveChildVCs()
        
        instantiateFoodDrinkVC(true)
    }
    
    func showDrinkOnly(navTitle: String) {
        self.customTitleView.text = navTitle
        self.customTitleView.sizeToFit()
        
        self.customTitleViewBorder.frame = CGRectMake(0, self.customTitleView.height,customTitleView.width, 1);
        self.customTitleViewBorder.backgroundColor = UIColor(hexString: StringConstants.navBarTextColor).CGColor
        
        checkAndRemoveChildVCs()
        
        instantiateFoodDrinkVC(false)
    }
    
    func ratingSort(navTitle: String) {
        self.customTitleView.text = navTitle
        self.customTitleView.sizeToFit()
        
        self.customTitleViewBorder.frame = CGRectMake(0, self.customTitleView.height,customTitleView.width, 1);
        self.customTitleViewBorder.backgroundColor = UIColor(hexString: StringConstants.navBarTextColor).CGColor
        
        checkAndRemoveChildVCs()
        instantiateHeaderlessView(false)
    }
    
    func alphaSort(navTitle: String) {
        self.customTitleView.text = navTitle
        self.customTitleView.sizeToFit()
        
        self.customTitleViewBorder.frame = CGRectMake(0, self.customTitleView.height, self.customTitleView.width, 1);
        self.customTitleViewBorder.backgroundColor = UIColor(hexString: StringConstants.navBarTextColor).CGColor
        
        checkAndRemoveChildVCs()
        instantiateHeaderlessView(true)
    }
    
    func instantiateHeaderlessView(isAlphaSort: Bool) {
        
        self.vcWithOutHeaders = ViewControllerWithoutHeadersViewController(isAlphaSort: isAlphaSort)
        
        self.addChildViewController(self.vcWithOutHeaders)
        
        self.view!.addSubview(self.vcWithOutHeaders.view)
        
        self.vcWithOutHeaders.didMoveToParentViewController(self)
    }
    
    func instantiateFoodDrinkVC(isFoodSort: Bool) {
        self.foodDrinkVC = FoodDrinkViewController(isFoodSort: isFoodSort)
        
        self.addChildViewController(self.foodDrinkVC)
        
        self.view!.addSubview(self.foodDrinkVC.view)
        
        self.foodDrinkVC.didMoveToParentViewController(self)
    }
    
    func checkAndRemoveChildVCs () {
        if self.vcWithOutHeaders != nil {
            self.vcWithOutHeaders.willMoveToParentViewController(nil)
            self.vcWithOutHeaders.view!.removeFromSuperview()
            self.vcWithOutHeaders.removeFromParentViewController()
            
            self.vcWithOutHeaders = nil
        }
        
        if self.foodDrinkVC != nil {
            self.foodDrinkVC.willMoveToParentViewController(nil)
            self.foodDrinkVC.view!.removeFromSuperview()
            self.foodDrinkVC.removeFromParentViewController()
            
            self.foodDrinkVC = nil
        }
    }
    
    func indexPathForSelectedRow(selectedButton: UIButton) -> NSIndexPath {
        
        let buttonPostion: CGPoint = selectedButton.convertPoint(CGPointZero, toView: self.tableView)
        
        return self.tableView.indexPathForRowAtPoint(buttonPostion)!
    }
    
    func returnDealsArray(indexPath: NSIndexPath) -> Array<DealDay> {
        
        let dataSourceKey: Int = self.viewModel.tableSections[indexPath.section]
        
        return self.viewModel.tableDataSource[dataSourceKey]!
    }
    
    func expandInfoCell(sender: UIButton) {
        
        let indexPath: NSIndexPath = indexPathForSelectedRow(sender)
        
        if let dealDay = getDealDayForIndexPath(indexPath) {
            var cell: LocationTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! LocationTableViewCell
            
            openInfoView(cell, dealDay: dealDay) { () -> Void in
                //
            }
        }
    }
    
    func openInfoView(cell: LocationTableViewCell, dealDay: DealDay, completed: () -> Void) {
        
        if dealDay.isOpen.boolValue {
             dealDay.isOpen = NSNumber(bool: false)
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            closeInfoView(cell, completed: { () -> Void in
                completed()
            })
        } else {
            
            cell.discloseButton.transformWithCompletion { (result) -> Void in
                cell.discloseButton.setImage(UIImage(named: "close"), forState: .Normal)
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    cell.discloseButton.transform = CGAffineTransformIdentity
                })
            }
            
            cell.containerView.bringSubviewToFront(cell.buttonView)
            
            dealDay.isOpen = NSNumber(bool: true)
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                cell.containerView.height = cell.containerView.height + 40
                cell.buttonView.height = 40
                cell.scheduleButton.height = 40
                cell.webSiteButton.height = 40
                cell.mapButton.height = 40
                }, completion: { (finished: Bool) -> Void in
                    completed()
            })
            
        }
        
    }
    
    func closeInfoView(cell: LocationTableViewCell, completed: () -> Void) {
        
        cell.discloseButton.transformWithCompletion { (result) -> Void in
            cell.discloseButton.setImage(UIImage(named: "disclose"), forState: .Normal)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                cell.discloseButton.transform = CGAffineTransformIdentity
            })
        }
       
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            cell.containerView.height = cell.containerView.height - 40
            cell.buttonView.height = 0
            cell.scheduleButton.height = 0
            cell.webSiteButton.height = 0
            cell.mapButton.height = 0
            }) { (finished: Bool) -> Void in
                completed()
        }
        
    }
    
    func reloadTable() {
        
        self.tableView.reloadData()
    }
    
}

