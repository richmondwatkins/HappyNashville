//
//  LocationWebViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/5/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class LocationWebViewController: UIViewController, UIWebViewDelegate {
    
    var location: Location
    var webView: UIWebView = UIWebView()
    let loadingAnimator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    var navBarHeight: CGFloat = 0
    let buttonPadding: CGFloat = 10
    
    init(location: Location, navBarHeight: CGFloat) {
        self.location = location
        self.navBarHeight = navBarHeight
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar: UIView = UIView(frame: CGRectMake(0, 0, self.view!.width, self.navBarHeight))
        navBar.backgroundColor = UIColor(hexString: StringConstants.primaryColor)
        
        let backButton: UIButton = UIButton(frame: CGRectMake(
            buttonPadding,
            (navBar.height / 2) - ((navBar.height / 2) / 2) + UIApplication.sharedApplication().statusBarFrame.size.height / 2,
            50,
            navBar.height / 2)
        )
        
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        navBar.addSubview(backButton)
        
        self.loadingAnimator.startAnimating()
        self.loadingAnimator.hidesWhenStopped = true
        self.loadingAnimator.frame = CGRectMake(
            navBar.width - self.loadingAnimator.width - buttonPadding,
            navBar.height / 2 - (self.loadingAnimator.height / 2) + UIApplication.sharedApplication().statusBarFrame.size.height / 2,
            self.loadingAnimator.width,
            self.loadingAnimator.height)
        
        navBar.addSubview(self.loadingAnimator)
        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = self.location.name
        titleLabel.font = UIFont.systemFontOfSize(18)
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .Center
        titleLabel.width = self.view!.width * 0.6
        titleLabel.center = CGPointMake(self.view.width / 2, navBar.height / 2 + UIApplication.sharedApplication().statusBarFrame.size.height / 2)
        titleLabel.textColor = .whiteColor()
        
        navBar.addSubview(titleLabel)
        
        self.view!.addSubview(navBar)
        
        self.webView.frame = CGRectMake(0, navBar.bottom, self.view!.width, self.view!.height - navBar.height)
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string:self.location.website)!))
        
        self.webView.delegate = self
        
        self.view!.addSubview(self.webView)
        
        self.view!.addSubview(self.loadingAnimator)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingAnimator.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.loadingAnimator.stopAnimating()
    }
    
    func backButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
