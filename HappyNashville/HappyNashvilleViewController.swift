//
//  HappyNashvilleViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 6/17/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import iAd

class HappyNashvilleViewController: UIViewController, ADBannerViewDelegate {

    let iAdHeight: CGFloat = 50
    var iAdIsOut: Bool = false
    var iAdBanner: ADBannerView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        if self.iAdBanner != nil {
            if self.iAdIsOut {
                self.iAdBanner!.frame = CGRectMake(
                    0,
                    self.view.height - self.iAdHeight,
                    self.view.width,
                    self.iAdHeight
                )
            } else {
                self.iAdBanner!.frame = CGRectMake(
                    0,
                    self.view.height,
                    self.view.width,
                    self.iAdHeight
                )
            }
        }
    }

    func setUpIAd() {
        self.iAdBanner = ADBannerView()
        self.view.addSubview(self.iAdBanner!)
        self.iAdBanner!.delegate = self
    }

    func bannerViewWillLoadAd(banner: ADBannerView!) {
        self.iAdIsOut = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.iAdBanner!.frame = CGRectMake(
                0,
                self.view.height - self.iAdHeight,
                self.view.width,
                self.iAdHeight
            )
        })
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.iAdIsOut = false
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.iAdBanner!.frame = CGRectMake(
                0,
                self.view.height,
                self.view.width,
                self.iAdHeight
            )
        })
    }
}
