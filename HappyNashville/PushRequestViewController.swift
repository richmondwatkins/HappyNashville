//
//  PushRequestViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 8/1/15.
//  Copyright © 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class PushRequestViewController: UIViewController {

    let popUpView: UIView = UIView()
    let titleLabel: UILabel = UILabel()
    let descriptionLabel: UILabel = UILabel()
    let okButton: UIButton = UIButton()
    let noButton: UIButton = UIButton()
    let noLayer: CALayer = CALayer()
    let buttonHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.backgroundColor = .whiteColor()
        popUpView.layer.cornerRadius = 2.0
        
        self.view.addSubview(popUpView)
        popUpView.addSubview(titleLabel)
        popUpView.addSubview(descriptionLabel)
        popUpView.addSubview(okButton)
        popUpView.addSubview(noButton)
        
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = "Hello Happy Nashvillian!"
        titleLabel.font = UIFont(name: "GillSans", size: 22)!
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.text = "Would you like to receive notifications for featured specials?"
        descriptionLabel.font = UIFont(name: "GillSans", size: 20)!
        
        okButton.backgroundColor = UIColor(hexString: StringConstants.primaryColor)
        okButton.setTitle("Ok!", forState: .Normal)
        okButton.addTarget(self, action: "okButtonSelected", forControlEvents: .TouchUpInside)
        
        noButton.setTitle("Nah", forState: .Normal)
        noButton.addTarget(self, action: "noButtonSelected", forControlEvents: .TouchUpInside)
        noButton.setTitleColor(UIColor(hexString: StringConstants.primaryColor), forState: .Normal)

        noLayer.backgroundColor = UIColor(hexString: StringConstants.primaryColor).CGColor

        popUpView.layer.addSublayer(noLayer)
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let popUpWidth = self.view.width * 0.8
        let popUpHeight = self.view.height * 0.5
        
        popUpView.frame = CGRect(
            x: self.view.width * 0.1,
            y: self.view.height / 2 - popUpHeight / 2,
            width: popUpWidth,
            height: popUpHeight
        )
        
        titleLabel.frame = CGRect(
            x: 0,
            y: 10,
            width: popUpView.width,
            height: 30
        )
        
        descriptionLabel.frame = CGRect(
            x: 4,
            y: titleLabel.bottom + 25,
            width: popUpView.width - 4,
            height: 100
        )
        
        okButton.frame = CGRect(
            x: 0,
            y: popUpView.height - buttonHeight,
            width: popUpView.width / 2,
            height: buttonHeight
        )
        
        noButton.frame = CGRect(
            x: okButton.right,
            y: popUpView.height - buttonHeight,
            width: popUpView.width / 2,
            height: buttonHeight
        )
        
        noLayer.frame = CGRect(
            x: okButton.right,
            y: popUpView.height - buttonHeight,
            width: popUpView.width / 2,
            height: 1
        )
    }
    
    func okButtonSelected() {
        dismissVC()
        
        let type: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound];
        let setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        UIApplication.sharedApplication().registerForRemoteNotifications();
    }
    
    func noButtonSelected() {
        dismissVC()
    }
    
    func dismissVC() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
             self.view.alpha = 0
            }) { (completed) -> Void in
                self.willMoveToParentViewController(self.parentViewController)
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
                let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                userDefaults.setBool(true, forKey: "Push"); userDefaults.synchronize()
        }
    }
}

