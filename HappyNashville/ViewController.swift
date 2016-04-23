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
import mopub_ios_sdk

let MoPubNativeAd = "b0f9ad30fcf14d44b52315c293e36a07"
let MoPubFullScreenAd = "172f90070d4a4fc5be613a5cdce806ab"
let MoPubMediuMad = "8fb71b3a1daf403a8d93f688d88851a8"
let MoPubBannerId = "9b1babba42e54dd880eceb9a108b1064"
let footerHeight: CGFloat = 60
//8fb71b3a1daf403a8d93f688d88851a8

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewModelProtocol, ScheduleProtocol, SortProtocol, LocationCellProtocol, SettingsProtocol, DaySelectionProtocol, MenuProtocol, UIScrollViewDelegate {
    
    var viewModel: ViewControllerViewModel!
    var tableView: UITableView = UITableView()
    var subView: UIView = UIView()
    var customTitleView: UILabel = UILabel()
    var customTitleViewBorder: CALayer = CALayer()
    var sortIsDisplaying: Bool = Bool()
    var footer: FooterViewController!
    var sortButton: UIBarButtonItem!
    var menuButton: UIBarButtonItem!
    var currentSort: String = ""
    var refreshControl: UIRefreshControl!
    var menuVC: MenuViewController?
    var isMenuOut: Bool = false
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    var sortViewController: SortViewController?
    let titleBottomPadding: CGFloat = 15
    let specialBottomPadding: CGFloat = 5
    let infoButtonsHeight: CGFloat = 30
    let infoButtonsTopPadding: CGFloat = 10
    let titleLabelHeight: CGFloat = 30
    let specialHeight: CGFloat = 15
    var placer: MPTableViewAdPlacer!
    // TODO: Replace this test id with your personal ad unit id
    var adView: MPAdView = MPAdView(adUnitId: MoPubBannerId, size: MOPUB_BANNER_SIZE)
    var bannerAdDisplaying: Bool = false {
        didSet {
            self.view.setNeedsLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel =  ViewControllerViewModel()
        
        self.subView.frame = self.view!.frame
        self.subView.addSubview(self.tableView)
        
        self.view!.addSubview(self.subView)
        self.view!.backgroundColor = UIColor.whiteColor()
        
        setTableView()
        
        self.viewModel.delegate = self
        
        if self.viewModel.tableSections.count - 1 > self.viewModel.getCurrentDay() {
            scrollToCurrentDay()
        } else if (self.viewModel.tableSections.count > 0) {
             self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }

        setUpMenuButton()
        setUpSortButton()
        setTitleView()
        setRefreshControl()
        addFooter()
        
        if self.viewModel.tableDataSource.count == 0 {
            self.activityIndicator.startAnimating()
            inactivateView()
        }
        
        setUpAds()
    }
    
    func setUpAds() {
        
        self.adView.delegate = self
        
        // Positions the ad at the bottom, with the correct size
        self.adView.frame = CGRect(x: (self.view.width / 2) - (MOPUB_BANNER_SIZE.width / 2), y: self.view.bounds.size.height - MOPUB_BANNER_SIZE.height, width:MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.view.addSubview(self.adView)
        
        // Loads the ad over the network
        self.adView.loadAd()
//        
        // Create the Static Native Ad renderer configuration.
        let staticSettings = MPStaticNativeAdRendererSettings()
        staticSettings.renderingViewClass = ACNativeAdCell.self
        staticSettings.viewSizeHandler = { (maxWidth: CGFloat) -> CGSize in
            
            return CGSize(width: maxWidth, height: maxWidth * 1.1)
        }
        
        let staticConfiguration = MPStaticNativeAdRenderer.rendererConfigurationWithRendererSettings(staticSettings)
        
        // Create the Native Video Ad renderer configuration.
        let videoSettings = MOPUBNativeVideoAdRendererSettings()
        videoSettings.renderingViewClass = staticSettings.renderingViewClass
        videoSettings.viewSizeHandler = staticSettings.viewSizeHandler
        
        let videoConfiguration = MOPUBNativeVideoAdRenderer.rendererConfigurationWithRendererSettings(videoSettings)
                
        placer = MPTableViewAdPlacer(tableView: self.tableView, viewController: self, rendererConfigurations: [staticConfiguration, videoConfiguration])
        
        placer.delegate = self
        
        // Add targeting parameters.
        let targeting = MPNativeAdRequestTargeting()
        
        targeting.desiredAssets = Set([kAdIconImageKey, kAdMainImageKey, kAdCTATextKey, kAdTextKey, kAdTitleKey])
        
        // Begin loading ads and placing them into your feed, using the ad unit ID.
        placer.loadAdsForAdUnitID(MoPubNativeAd)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.tableView.frame = CGRectMake(
            0,
            0,
            self.view!.width,
            self.view!.height - self.footer.view.height
        )
        
        let bannerSize: CGFloat = bannerAdDisplaying ? MOPUB_BANNER_SIZE.height : 0
        
        self.footer.view.frame = CGRectMake(0, self.originalContentView!.bottom - footerHeight - bannerSize, self.view!.width, footerHeight)
        
        if bannerAdDisplaying {
            self.tableView.contentInset = UIEdgeInsets(
                top: self.footer.view.height,
                left: 0,
                bottom: self.footer.view.height,
                right: 0
            )
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

        if !userDefaults.boolForKey("Push") {
            askForPushRequest()
        }
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor(hexString: StringConstants.grayShade)
        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    }
    
    func setTitleView() {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: StringConstants.primaryColor)
        self.customTitleView.backgroundColor = .clearColor()
        self.customTitleView.textColor = UIColor(hexString: StringConstants.navBarTextColor)
        self.customTitleView.textAlignment = .Center
        
        self.navigationItem.titleView = self.customTitleView
        
        self.activityIndicator.center = self.navigationItem.titleView!.center
        self.navigationItem.titleView?.addSubview(self.activityIndicator);
    }
    
    func setRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func askForPushRequest() {
        let pushRequestVC = PushRequestViewController()
        
        self.addChildViewController(pushRequestVC)
        self.view.addSubview(pushRequestVC.view)
        pushRequestVC.didMoveToParentViewController(self)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
    
    func refreshData() {
        inactivateView()
        
        self.viewModel.fetchData(false)
    }
    
    func setUpSortButton() {
        sortButton = UIBarButtonItem(image: UIImage(named: "filter"), style: UIBarButtonItemStyle.Plain, target: self, action: "displaySortOptions:")
        sortButton.tintColor = .whiteColor()
        self.navigationItem.rightBarButtonItem = sortButton
    }
    
    func setUpMenuButton() {
        menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        
        menuButton.tintColor = .whiteColor()
        
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    func addFooter() {
        self.footer = FooterViewController(viewFrame:
            CGRectMake(0, self.originalContentView!.bottom - footerHeight - MOPUB_BANNER_SIZE.height, self.view!.width, footerHeight))
        footer.delegate = self
        
        self.addChildViewController( self.footer)
        self.view!.addSubview( self.footer.view)
        self.footer.didMoveToParentViewController(self)
    }

    func scrollToCurrentDay() {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: self.viewModel.getCurrentDay() - 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionDay: Int = self.viewModel.tableSections[section]
        
        if let array = self.viewModel.tableDataSource[sectionDay] {
            return array.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel.tableSections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionDay: Int = self.viewModel.tableSections[section]
        
        if (self.viewModel.tableDataSource[sectionDay] != nil) {
            return self.viewModel.dayForDayNumber(self.viewModel.tableSections[section])
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader: UIView = UIView();
        sectionHeader.backgroundColor = UIColor(hexString: "E9E9E9")
        
        let headerLabel: UILabel = UILabel();
        headerLabel.text = self.viewModel.dayForDayNumber(self.viewModel.tableSections[section])
        headerLabel.font = UIFont(name: "GillSans-Bold", size: 20)!
        headerLabel.sizeToFit()
        
        sectionHeader.addSubview(headerLabel)
        
        headerLabel.frame = CGRectMake(8, 20 - headerLabel.height / 2, headerLabel.width, headerLabel.height)
        
        return sectionHeader
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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

        let dealDay: DealDay = getDealDayForIndexPath(indexPath)!
        
        if dealDay.isOpen.boolValue {
            return CGFloat(dealDay.height.integerValue) + 40
        } else {
            return CGFloat(dealDay.height.integerValue)
        }
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if let menu = self.menuVC {
            menu.dimissView()
            self.menuVC = nil
        }
    }

    func configureCell(cell: LocationTableViewCell, dealDay: DealDay) {
        cell.setSpecialViewDealDay(dealDay);
        cell.reDisplay()
        
        cell.delegate = self
        
        let cellHeight: CGFloat = getCellHeight(dealDay)
        
        cell.containerView.frame = CGRectMake(0, 0, self.view!.width * 0.95, cellHeight * 0.95)
        cell.containerView.center = CGPointMake(self.view!.width / 2, cellHeight / 2)
        
        cell.contentCard.frame = CGRectMake(0, 0, cell.containerView.width, cell.containerView.height - self.infoButtonsHeight)

        cell.buttonView.frame = CGRectMake(0, cell.contentCard.bottom, cell.containerView.width, self.infoButtonsHeight)

        let buttonViewHeight = cell.buttonView.height
        let buttonViewWidth: CGFloat = 130
        let buttonPadding: CGFloat = 4
        
        let buttonMeasurements = self.viewModel.getButtonWidth(buttonViewWidth, numberOfButtons: CGFloat(3), padding: 8)
        
        cell.buttonLayer.frame = CGRectMake(0, 0, cell.buttonView.width, 1)

        cell.webSiteButton.frame = CGRectMake(
            cell.contentCard.right - buttonMeasurements.buttonPadding - buttonMeasurements.buttonWidth,
            buttonPadding,
            buttonMeasurements.buttonWidth,
            buttonViewHeight - buttonPadding * 2
        )
        
        cell.mapButton.frame = CGRectMake(
            cell.webSiteButton.left - buttonMeasurements.buttonPadding - buttonMeasurements.buttonWidth,
            buttonPadding,
            buttonMeasurements.buttonWidth,
            buttonViewHeight - buttonPadding * 2
        )

        cell.scheduleButton.frame = CGRectMake(
            cell.mapButton.left - buttonMeasurements.buttonPadding - buttonMeasurements.buttonWidth,
            buttonPadding,
            buttonMeasurements.buttonWidth,
            buttonViewHeight - buttonPadding * 2
        )
        cell.scheduleButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        
        if let uberButton = cell.uberButton {
            uberButton.frame = CGRect(
                x: cell.scheduleButton.left - buttonMeasurements.buttonPadding - buttonMeasurements.buttonWidth - 5,
                y: buttonPadding,
                width: buttonMeasurements.buttonWidth + 5,
                height: buttonViewHeight - buttonPadding * 2
            )
            
            cell.buttonView.layer.addSublayer(
                getButtonDividerLayer(
                    self.infoButtonsHeight,
                    xValue:cell.uberButton!.left - ((cell.scheduleButton.left - cell.mapButton.right) / 2) + 5
                )
            )
            
            uberButton.addTarget(self, action: "openUberModel:", forControlEvents: .TouchUpInside)
        }

        cell.buttonView.layer.addSublayer(
            getButtonDividerLayer(
                self.infoButtonsHeight,
                xValue:cell.scheduleButton.left - ((cell.scheduleButton.left - cell.mapButton.right) / 2)
            )
        )
        cell.buttonView.layer.addSublayer(
            getButtonDividerLayer(
                self.infoButtonsHeight,
                xValue:cell.mapButton.left - ((cell.mapButton.left - cell.webSiteButton.right) / 2)
            )
        )
        
        let ratingViewWidth: CGFloat = 80
        
        if dealDay.location.distanceFromUser.doubleValue > 0 {
            cell.ratingView.frame = CGRectMake(
                5,
                2,
                ratingViewWidth,
                titleBottomPadding
            )
        } else {
            cell.ratingView.frame = CGRectMake(
                5, (cell.buttonView.height / 2) - (titleBottomPadding / 2), ratingViewWidth, titleBottomPadding)
        }

        if dealDay.location.rating != NSNull() {
            cell.ratingView.value = CGFloat(dealDay.location.rating.doubleValue)
        }
        
        if dealDay.location.distanceFromUser.doubleValue > 0 {
            cell.distanceLabel.text = String(format: "approx. %.2f mi", dealDay.location.distanceFromUser.doubleValue)
            cell.distanceLabel.sizeToFit()
            cell.distanceLabel.frame = CGRectMake(
                8,
                cell.ratingView.bottom,
                cell.distanceLabel.width,
                cell.distanceLabel.height
            )
        }
        
        cell.notifImageView.frame = CGRectMake(self.view!.width - 40 - 2, 10, 20, 20)
        if self.viewModel.checkForNotification(dealDay) {
            cell.notifImageView.hidden = false
            cell.scheduleButton.addTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
        } else {
            cell.notifImageView.hidden = true
            cell.scheduleButton.setImage(UIImage(named: "schedule"), forState: .Normal)
            cell.scheduleButton.addTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
        }
    }
    
    func getButtonDividerLayer(height: CGFloat, xValue: CGFloat) -> CALayer {
        let newLayer: CALayer = CALayer()
        newLayer.frame = CGRectMake(xValue, 0, 1, height)
        newLayer.backgroundColor = UIColor(hexString: StringConstants.primaryColor).CGColor
        
        return newLayer
    }
    
    func getCellHeight(dealDay: DealDay) -> CGFloat {
        
        return self.viewModel.calculateCellHeight(dealDay, specialCount: dealDay.specials.count)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let dealDay = getDealDayForIndexPath(indexPath) {
      
            let detailViewController: DetailViewController =
                DetailViewController(location: dealDay.location, dealDay: dealDay)
                        
            self.navigationController?.pushViewController(detailViewController, animated: true)
            
            setUpBackButton()
        }
    }
    
    func setUpBackButton() {
        let barButtonItem:UIBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        barButtonItem.tintColor = .whiteColor()
        
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    func webSiteButtonPressed(sender: UIButton) {
        
        let shareVC: ShareViewController = ShareViewController(dealDay: returnSelectedDealDay(sender).dealDay)
        
        self.addChildViewController(shareVC)
        self.view!.addSubview(shareVC.view)
        shareVC.didMoveToParentViewController(self)
    }

    func scheduleButtonPressed(sender: UIButton) {
        
        let selectedDay = returnSelectedDealDay(sender)
        
        let scheduleViewController: ScheduleViewController = ScheduleViewController(
            dealDay: selectedDay.dealDay,
            navHeight: self.navigationController!.navigationBar.height + UIApplication.sharedApplication().statusBarFrame.height,
            indexPath: returnSelectedDealDay(sender).indexPath
        )
        
        scheduleViewController.delegate = self
        
        self.addChildViewController(scheduleViewController)
        self.subView.transformAndAddSubview(scheduleViewController.view)
        scheduleViewController.didMoveToParentViewController(self)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.footer.view.alpha = 0
        })
        
        self.sortButton.enabled = false
        self.menuButton.enabled = false
    }
    
    func mapButtonPressed(sender: UIButton) {
        
        let dealDay: DealDay = returnSelectedDealDay(sender).dealDay
        
        let mapViewController: MapViewController = MapViewController(location: dealDay.location, locations: self.viewModel.locations)
        
        self.navigationController?.pushViewController(mapViewController, animated: true)
        
        setUpBackButton()
    }
    
    func unscheduleNotification(sender: UIButton) {
        
        let indexPath: NSIndexPath = indexPathForSelectedRow(sender)
        
        let dealDay = returnSelectedDealDay(sender).dealDay
        dealDay.notification = nil
        self.viewModel.unscheduleNotification(dealDay)
        
        let cell: LocationTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! LocationTableViewCell
        
        cell.scheduleButton.setImage(UIImage(named: "schedule"), forState: .Normal)
        cell.scheduleButton.removeTarget(self, action: "unscheduleNotification:", forControlEvents:.TouchUpInside)
        cell.scheduleButton.addTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
        cell.notifImageView.hidden = true
    }
    
    func updateScheduledCell(indexPath: NSIndexPath) {
        
        let cell: LocationTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! LocationTableViewCell
        
        cell.scheduleButton.removeTarget(self, action: "scheduleButtonPressed:", forControlEvents:.TouchUpInside)
        
        configureCell(cell, dealDay: getDealDayForIndexPath(indexPath)!)
    }
    
    func showFooter() {
        self.sortButton.enabled = true
        self.menuButton.enabled = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.footer.view.alpha = 1
        })
    }
    
    func returnSelectedDealDay(selectedButton: UIButton) -> (dealDay: DealDay, indexPath: NSIndexPath) {
        
        let indexPath: NSIndexPath = indexPathForSelectedRow(selectedButton)
        
        return (getDealDayForIndexPath(indexPath)!, indexPath)
    }
    
    func getDealDayForIndexPath(indexPath: NSIndexPath) -> DealDay? {
        
        let dataSourceKey: Int = self.viewModel.tableSections[indexPath.section]
        
        // TODO: watch for crash
        let dealDays = self.viewModel.tableDataSource[dataSourceKey]!
        
        if dealDays.count - 1 >= indexPath.row {
            return dealDays[indexPath.row]
        } else {
            return nil
        }
    }
    
    func showMenu(sender: UIButton) {
        if let menu = self.menuVC {
            menu.dimissView()
            self.menuVC = nil
        } else {
            menuVC = MenuViewController(viewFrame:
                CGRectMake(
                    0,
                    self.navigationController!.navigationBar.height + UIApplication.sharedApplication().statusBarFrame.size.height,
                    self.view.width,
                    self.view.height / 4
                )
            )
            
            self.addChildViewController(menuVC!)
            self.view.addSubview(menuVC!.view)
            menuVC!.didMoveToParentViewController(self)
            
            menuVC!.delegate = self
        }
    }
    
    func displayMapView() {
        let mapVC: MapViewController = MapViewController(location: nil, locations: self.viewModel.locations)
        
        self.navigationController?.pushViewController(mapVC, animated: true)
        
        setUpBackButton()
    }
    
    func setMenuDissmissed() {
        self.menuVC = nil
    }
    
    func displayNotificationManager() {
        let notificationViewController: NotificationsManagerViewController = NotificationsManagerViewController(navBarHeight: self.navigationController!.navigationBar.height)
        notificationViewController.delegate = self
        
        self.presentViewController(notificationViewController, animated: true, completion: nil)
    }
    
    func displaySortOptions(sender: UIButton) {
        
        if (self.sortViewController == nil) {
            self.sortViewController = SortViewController(
                sortTitle: self.currentSort,
                navBottom:
                self.navigationController!.navigationBar.height +
                    UIApplication.sharedApplication().statusBarFrame.size.height
            )
            
            sortViewController!.delegate = self
            
            self.addChildViewController(sortViewController!)
            
            sortViewController!.view.alpha = 0
            
            self.view!.addSubview(sortViewController!.view)
            
            sortViewController!.didMoveToParentViewController(self)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.sortViewController!.view.alpha = 1
            })
        } else {
            self.sortViewController?.willMoveToParentViewController(nil)
            self.sortViewController?.view!.removeFromSuperview()
            self.sortViewController?.removeFromParentViewController()
            self.sortViewController = nil
        }
    }
    
    func resetSort(navTitle: String) {
        self.currentSort = navTitle
        self.customTitleView.text = navTitle
        self.customTitleView.sizeToFit()
        
        self.customTitleViewBorder.frame = CGRectZero
        self.customTitleViewBorder.backgroundColor = UIColor.clearColor().CGColor
        
        self.viewModel.resetSort()
    }
    
    func showFoodOnly(navTitle: String) {
        self.currentSort = navTitle
        self.customTitleView.text = navTitle
        self.customTitleView.textAlignment = .Center
        self.customTitleView.sizeToFit()
        
        self.customTitleViewBorder.frame = CGRectMake(self.customTitleView.width / 2, self.customTitleView.height,customTitleView.width, 1);
        self.customTitleViewBorder.backgroundColor = UIColor(hexString: StringConstants.navBarTextColor).CGColor
        
        self.viewModel.sortByType(6)
    }
    
    func showDrinkOnly(navTitle: String) {
        setNavTitle(navTitle)
        
        self.viewModel.sortByType(0)
        
        self.tableView.reloadData()
    }
    
    func sortByLocation(navTitle: String) {
        self.viewModel.shouldSort = true
        self.viewModel.requestUserLocation()
        
        setNavTitle(navTitle)
    }
    
    func setNavTitle(title: String) {
        self.currentSort = title
        self.customTitleView.text = title
        self.customTitleView.sizeToFit()
        
        self.customTitleViewBorder.frame = CGRectMake(0, self.customTitleView.height, customTitleView.width, 1);

        self.customTitleViewBorder.backgroundColor = UIColor(hexString: StringConstants.navBarTextColor).CGColor
    }
    
    func indexPathForSelectedRow(selectedButton: UIButton) -> NSIndexPath {
        
        let buttonPostion: CGPoint = selectedButton.convertPoint(CGPointZero, toView: self.tableView)
        
        return self.tableView.indexPathForRowAtPoint(buttonPostion)!
    }
    
    func returnDealsArray(indexPath: NSIndexPath) -> Array<DealDay> {
        
        let dataSourceKey: Int = self.viewModel.tableSections[indexPath.section]
        
        return self.viewModel.tableDataSource[dataSourceKey]!
    }
       
    func reloadTable() {
        self.tableView.reloadData()
        self.scrollToCurrentDay()
        self.activityIndicator.stopAnimating()
        
        if self.refreshControl.refreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    func refreshTable() {
        self.tableView.reloadData()
        
        if self.refreshControl.refreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    func nullifySortVC() {
        self.sortViewController = nil
    }
    
    func retrieveLocations() -> Array<Location> {
        return self.viewModel.locations
    }
    
    func slideTableToSection(section: Int) {
        
        let scrollToPath: NSIndexPath = NSIndexPath(forRow: 1, inSection: section)
        
        self.tableView.scrollToRowAtIndexPath(scrollToPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func openDetailView(notification: UILocalNotification) {
        let userInfo = notification.userInfo!

        if let location = self.viewModel.returnLocationFromName(userInfo["location"] as! String) {
            let detailViewController: DetailViewController =
                DetailViewController(location: location, dealDay: nil)
            
            self.presentViewController(detailViewController, animated: true, completion: nil)
        }
    }
    
    func openUberModel(button: UIButton) {
        button.highlighted = false
        let dealDay: DealDay? = self.getDealDayForIndexPath(self.indexPathForSelectedRow(button))
        let uberVC: UberViewController = UberViewController(dealDay: dealDay)
        
        uberVC.view.frame = self.view.frame
        
        self.addChildViewController(uberVC)
        self.view.addSubview(uberVC.view)
        uberVC.willMoveToParentViewController(self)
    }
    
    func activateView() {
        self.footer.view.userInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.enabled = true
        self.navigationItem.rightBarButtonItem?.enabled = true
    }
    
    func inactivateView() {
        self.footer.view.userInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
}

extension ViewController: MPTableViewAdPlacerDelegate {
    
    func nativeAdWillBeInsertedAtIndex(indexPath: NSIndexPath!) {
        
    }
}

extension ViewController: MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController {
        return self
    }
    
    func adViewDidLoadAd(view: MPAdView!) {
        self.bannerAdDisplaying = true
        self.adView.hidden = false
    }
    
    func adViewDidFailToLoadAd(view: MPAdView!) {
        self.bannerAdDisplaying = false
        self.adView.hidden = true
    }

}