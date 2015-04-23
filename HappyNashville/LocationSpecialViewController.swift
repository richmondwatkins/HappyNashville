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
    
    init(dealDay: DealDay) {
        super.init(nibName: nil, bundle: nil)
        
        self.dealDay = dealDay
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var top: CGFloat = 0
        
        self.scrollView = UIScrollView(frame: self.view!.frame)
        
        self.view! = self.scrollView!

        for special in self.viewModel.sortSpecialsByTime(self.dealDay!.specials) as! [Special] {
            
            let specialView: LocationSpecialView = LocationSpecialView(special: special, frame: CGRectMake(0, 0, self.view!.width, 0))
            
            self.scrollView!.addSubview(specialView)
            
            specialView.top = top
            
            top = specialView.bottom + 4
            
            self.contentHeight += specialView.height + 2
        }
        
        self.scrollView?.contentSize = CGSizeMake(self.view!.width, self.contentHeight)
        self.scrollView?.scrollEnabled = true
    }

}
