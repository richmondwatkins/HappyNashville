//
//  ShareViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/19/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import Social
import MessageUI

class ShareViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {

    var shareView: UIView = UIView()
    let titleLabel: UILabel = UILabel()
    let smsButton: UIButton = UIButton()
    let emailButton: UIButton = UIButton()
    let closeButton: UIButton = UIButton()
    var dealDay: DealDay!
    var viewModel = AppViewModel()
    
    init(dealDay: DealDay) {
        super.init(nibName: nil, bundle: nil)
        
        self.dealDay = dealDay
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.view!.alpha = 0
        self.view.tag = 1
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "close")
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapGesture)
       
        self.view!.addSubview(shareView)
        
        setUpShareView()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view!.alpha = 1
        })
    }
    
    override func viewWillLayoutSubviews() {
        let padding: CGFloat = 30
        let shareHeightWidth: CGFloat = self.view!.width - padding * 2
        
        shareView.frame = CGRectMake(
            padding,
            self.view!.height / 2 - shareHeightWidth / 2,
            shareHeightWidth,
            shareHeightWidth - 40
        )
        shareView.backgroundColor = .whiteColor()
        
        titleLabel.frame = CGRectMake(0, 0, shareView.width, 30)
        
        closeButton.frame = CGRectMake(padding, shareView.height - 10 - 30, shareView.width - padding * 2, 30)

        
        let buttonWidth: CGFloat = shareView.center.x - padding * 2
        let buttonHeight: CGFloat = closeButton.top - titleLabel.bottom - 40
        
        smsButton.frame = CGRectMake(padding, titleLabel.bottom + 10, buttonWidth, buttonHeight)
        emailButton.frame = CGRectMake(smsButton.right, titleLabel.bottom + 10, buttonWidth, buttonHeight)
        
        let spacing: CGFloat = 10
        
        let smsButtonImageSize: CGSize = smsButton.imageView!.image!.size;
        
        smsButton.titleEdgeInsets = UIEdgeInsetsMake(
            0.0, -smsButtonImageSize.width, -(smsButtonImageSize.height + spacing), 0.0);
        
        let smsButtonTitleSize: CGSize = smsButton.titleLabel!.text!.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16)])
        
        smsButton.imageEdgeInsets = UIEdgeInsetsMake(
            -(smsButtonTitleSize.height + spacing), 0.0, 0.0, -smsButtonTitleSize.width);
        
        
        let emailButtonImageSize: CGSize = emailButton.imageView!.image!.size;
        
        emailButton.titleEdgeInsets = UIEdgeInsetsMake(
            20.0, -emailButtonImageSize.width, -(emailButtonImageSize.height + spacing), 0.0);
        
        let emailButtonTitleSize: CGSize = emailButton.titleLabel!.text!.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16)])
        
        emailButton.imageEdgeInsets = UIEdgeInsetsMake(
            -(emailButtonTitleSize.height + spacing), 0.0, 0.0, -emailButtonTitleSize.width);
    }
    
    func setUpShareView() {
        titleLabel.text = "Share via:"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor(hexString: StringConstants.primaryColor)

        smsButton.setTitle("Text", forState: .Normal)
        emailButton.setTitle("Email", forState: .Normal)
        closeButton.setTitle("Close", forState: .Normal)
        closeButton.titleLabel?.textAlignment = .Center
        closeButton.backgroundColor = UIColor(hexString: StringConstants.primaryColor)
        
        closeButton.addTarget(self, action: "close", forControlEvents: .TouchUpInside)
        smsButton.addTarget(self, action: "sendText", forControlEvents: .TouchUpInside)
        emailButton.addTarget(self, action: "sendEmail", forControlEvents: .TouchUpInside)
        
        emailButton.setImage(UIImage(named: "email"), forState: .Normal)
        smsButton.setImage(UIImage(named: "sms"), forState: .Normal)
        
        emailButton.setTitleColor(UIColor(hexString: StringConstants.primaryColor), forState: .Normal)
        smsButton.setTitleColor(UIColor(hexString: StringConstants.primaryColor), forState: .Normal)
        
        shareView.layer.cornerRadius = 3.0
        closeButton.layer.cornerRadius = 3.0
        
        shareView.addSubview(titleLabel)
        shareView.addSubview(closeButton)
        shareView.addSubview(smsButton)
        shareView.addSubview(emailButton)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            
            var messageString = "\(dealDay.location.name) has the following specials on \(self.viewModel.dayForDayNumber(dealDay.day.integerValue)):"
            
            for special in dealDay.specials.allObjects as! [Special] {
                messageString += " \(special.specialDescription)"
            }
            
            let mailVC: MFMailComposeViewController = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setMessageBody(messageString, isHTML: false)
            mailVC.setSubject("Let's go to happy hour!")
            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(mailVC, animated: true, completion: nil)
        }
    }
    
    func sendText() {
        if MFMessageComposeViewController.canSendText() {
            var messageString = "Let's go to happy hour! \(dealDay.location.name) has the following specials on \(self.viewModel.dayForDayNumber(dealDay.day.integerValue)):"
            
            for special in dealDay.specials.allObjects as! [Special] {
                messageString += " \(special.specialDescription)"
            }
            
            let messageVC: MFMessageComposeViewController = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.body = messageString
            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(messageVC, animated: true, completion: nil)
        }
    }
    
    func close() {
        self.willMoveToParentViewController(nil)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.alpha = 0
        }) { (complete) -> Void in
            self.view!.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view.tag == 1 {
            return true
        } else {
            return false
        }
    }
}
