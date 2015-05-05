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
    let loadingAnimator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var navBarHeight: CGFloat = 0
    let buttonPadding: CGFloat = 10
    
    init(location: Location, navBarHeight: CGFloat) {
        self.location = location
        self.navBarHeight = navBarHeight
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navBar: UIView = UIView(frame: CGRectMake(0, 0, self.view!.width, self.navBarHeight))
        navBar.backgroundColor = UIColor(hexString: "F8F8F8")
        
        var backButton: UIButton = UIButton(frame: CGRectMake(buttonPadding, (navBar.height / 2) - ((navBar.height / 2) / 2) , 50, navBar.height / 2))
        
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        navBar.addSubview(backButton)
        
        self.loadingAnimator.startAnimating()
        self.loadingAnimator.hidesWhenStopped = true
        self.loadingAnimator.frame = CGRectMake(navBar.width - self.loadingAnimator.width - buttonPadding, navBar.height / 2 - (self.loadingAnimator.height / 2), self.loadingAnimator.width, self.loadingAnimator.height)
        
        navBar.addSubview(self.loadingAnimator)
        
        var titleLabel: UILabel = UILabel()
        titleLabel.text = self.location.name
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.sizeToFit()
        titleLabel.width = self.view!.width * 0.6
        titleLabel.center = CGPointMake(navBar.width/2, navBar.height/2)
        
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
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.loadingAnimator.stopAnimating()
    }
    
    func backButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
