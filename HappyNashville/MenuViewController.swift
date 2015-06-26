//
//  MenuViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/27/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import MessageUI

@objc protocol MenuProtocol {
    func displayMapView()
    func setMenuDissmissed()
    func displayNotificationManager()
}

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate,
UIGestureRecognizerDelegate, UIAlertViewDelegate {

    var viewFrame: CGRect!
    var hasLoaded: Bool = false
    var delegate: MenuProtocol?
    var isMapView: Bool = true
    let scheduleNotifButton: UIButton = UIButton()
    let mapListButton: UIButton = UIButton()
    let reportButton: UIButton = UIButton()
    let hideAdsButton: UIButton = UIButton()
    var buttons: Array<UIButton>?
    
    init(viewFrame: CGRect) {
        self.viewFrame = viewFrame
        
        buttons = [
            scheduleNotifButton,
            mapListButton
        ]
        
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hexString: StringConstants.grayShade)
        view.frame = CGRectMake(0, -(self.viewFrame.size.height), self.viewFrame.size.width, self.viewFrame.size.height)
        self.view.layer.cornerRadius = 2
        self.view.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.8
        
        view.addSubview(scheduleNotifButton)
        view.addSubview(mapListButton)
        view.addSubview(reportButton)
        
        view.userInteractionEnabled = true
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: nil)
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Up
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.delegate = self
        view.addGestureRecognizer(swipeGesture)
        
        setUpButtons()
        setUpNotifButton()
        
        if isMapView {
            setUpMapButton()
        } else {
            setUpListView()
        }
        
        setUpReportButton()
    }

    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = self.viewFrame
            }) { (complete) -> Void in
                self.hasLoaded = true
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            dimissView()
        }
        
        return true
    }
    
    func restorePurchase() {
        hideAdsButton.removeFromSuperview()
        NSNotificationCenter.defaultCenter().postNotificationName("removeAds", object: nil)
    }
    
    func setUpButtons() {
        for button in buttons! {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor(hexString: StringConstants.primaryColor).CGColor
            button.titleLabel?.font = UIFont.systemFontOfSize(11)
            button.backgroundColor = .whiteColor()
            button.setTitleColor(UIColor(hexString: "3D3D3E"), forState: .Normal)
        }
    }
    
    func setUpReportButton() {
        reportButton.titleLabel?.font = UIFont.systemFontOfSize(8)
        reportButton.setTitleColor(UIColor(hexString: "3D3D3E"), forState: .Normal)
        reportButton.setTitle("Report Incorrect Special or Location", forState: .Normal)
        reportButton.setImage(UIImage(named: "report-flag"), forState: .Normal)
        reportButton.addTarget(self, action: "reportSpecialOrLoc", forControlEvents: .TouchUpInside)
    }
    
    func setUpMapButton() {
        mapListButton.setTitle("Map View", forState: .Normal)
        mapListButton.setImage(UIImage(named: "map-menu"), forState: .Normal)
        mapListButton.addTarget(self, action: "showMap", forControlEvents: .TouchUpInside)
    }
    
    func setUpListView() {
        mapListButton.setTitle("List View", forState: .Normal)
        mapListButton.setImage(UIImage(named: "map-menu"), forState: .Normal)
        mapListButton.addTarget(self, action: "showList", forControlEvents: .TouchUpInside)
    }
    
    func reportSpecialOrLoc() {
        if MFMailComposeViewController.canSendMail() {
            
            var messageString = "Please include name of the incorrect location and what is wrong with it"

            let mailVC: MFMailComposeViewController = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setMessageBody(messageString, isHTML: false)
            mailVC.setToRecipients(["happynashville.contact@gmail.com"])
            mailVC.setSubject("Incorrect Location or Special")
            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(mailVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showMap() {
        self.dimissView()
        delegate?.displayMapView()
    }
    
    func showList() {
        self.dimissView()
    }
    
    func setUpNotifButton() {
        scheduleNotifButton.setTitle("Manage Notifications", forState: .Normal)
        scheduleNotifButton.setImage(UIImage(named: "bell-menu"), forState: .Normal)
        scheduleNotifButton.addTarget(self, action: "showNotificationView", forControlEvents: .TouchUpInside)
    }
    
    func showNotificationView() {
        self.delegate?.displayNotificationManager()
    }
    
    func dimissView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectMake(0, -(self.viewFrame.size.height), self.view.width, self.view.height)
        }) { (complete) -> Void in
            self.willMoveToParentViewController(self.parentViewController)
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
            self.delegate?.setMenuDissmissed()
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        let buttonWidth:CGFloat = 100
        
        hideAdsButton.frame = CGRectMake(
            self.view.width - buttonWidth - 2,
            self.viewFrame.height - 25,
            buttonWidth,
            20
        )
        
        scheduleNotifButton.frame = CGRectMake(2, 2, (view.width / 2) - 3, view.height * 0.7)
        mapListButton.frame = CGRectMake(scheduleNotifButton.right + 2, 2, (view.width / 2) - 3, view.height * 0.7)
        reportButton.frame = CGRectMake(
            2,
            self.viewFrame.height - view.height * 0.17,
            view.width,
            view.height * 0.17
        )
        
        scheduleNotifButton.titleEdgeInsets = UIEdgeInsetsMake(scheduleNotifButton.height / 2 + 12, -35, 0, -1)
        scheduleNotifButton.imageEdgeInsets = UIEdgeInsets(
            top: -20,
            left: (scheduleNotifButton.width / 2) - (scheduleNotifButton.imageView!.image!.size.width / 2),
            bottom: 0,
            right: 0
        )
        
        mapListButton.titleEdgeInsets = UIEdgeInsetsMake(mapListButton.height / 2 + 12, -39, 0, -1)
        mapListButton.imageEdgeInsets = UIEdgeInsets(
            top: -20,
            left: (mapListButton.width / 2) - (mapListButton.imageView!.image!.size.width / 2) - 15,
            bottom: 0,
            right: 0
        )

        reportButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.view.width / 1.9) + 5, 0, 0)
        reportButton.imageEdgeInsets = UIEdgeInsets(
            top: -2,
            left: -(self.view.width / 1.9),
            bottom: 0,
            right: 0
        )
        
        self.view.bringSubviewToFront(hideAdsButton)
    }
}
