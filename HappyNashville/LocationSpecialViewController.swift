//
//  LocationSpecialViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/18/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class LocationSpecialViewController: UIViewController {

    var index: Int = Int()
    var dealDay: DealDay?
    var viewModel:LocationSpecialViewModel = LocationSpecialViewModel()
    var scrollView: UIScrollView?
    var contentHeight: CGFloat = 0
    var top: CGFloat!
    var noDealsView: UILabel = UILabel()
    
    init(dealDay: DealDay, top: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        
        self.top = top
        self.dealDay = dealDay
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = UIScrollView(frame: self.view!.frame)
        self.view! = self.scrollView!
        createNoDealsView()
        createScrollView()
    }
    
    func createScrollView() {
        for special in self.viewModel.sortSpecialsByTime(self.dealDay!.specials) as! [Special] {
            
            let specialView: LocationSpecialView = LocationSpecialView(special: special, frame: CGRectMake(0, 0, self.view!.width, 0))
            
            specialView.tag = 1

            self.scrollView!.addSubview(specialView)
            
            specialView.top = top
            
            top = specialView.bottom + 10
            
            self.contentHeight += specialView.height + 2
        }
        
        self.scrollView?.contentSize = CGSizeMake(self.view!.width, self.contentHeight + 50)
        self.scrollView?.scrollEnabled = true
    }
    
    func removeAllSpecialView() {
        for view in self.scrollView!.subviews {
            if view.tag == 1 {
                view.removeFromSuperview()
            }
        }
    }
    
    func hideAllSpecials() {
        for view in self.scrollView!.subviews as! [UIView]{
            if view.tag == 1 {
                view.alpha = 0
            }
        }
    }
    
    func changeDealDay(dealDay: DealDay) {
        self.dealDay = dealDay
        
        let originalCenter = self.scrollView!.center
        self.top = 2

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.noDealsView.alpha = 0
            self.scrollView!.center = CGPointMake(self.scrollView!.center.x, -(self.scrollView!.height))
            self.hideAllSpecials()
        }) { (complete) -> Void in
            self.removeAllSpecialView()
            self.createScrollView()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView!.center = originalCenter
                }) { (complete) -> Void in
                    //
            }
        }
    }
    
    func createNoDealsView() {
        noDealsView.frame = CGRectMake(0, 0, self.view!.width, 100)
        noDealsView.text = "There are no deals at \(self.dealDay!.location.name) on this day"
        noDealsView.textAlignment = .Center
        noDealsView.numberOfLines = 0
        noDealsView.alpha = 0
        self.scrollView!.addSubview(noDealsView)
    }
    
    func showNoDealsView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.hideAllSpecials()
            self.noDealsView.alpha = 1
        })
    }

}
