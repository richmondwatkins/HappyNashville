//
//  ScheduleViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/3/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UIGestureRecognizerDelegate, ScheduleViewProtocol {

    var deal: Deal?
    var scheduleView: ScheduleView?
    var viewModel: ScheduleViewControllerViewModel = ScheduleViewControllerViewModel()
    
    init(deal: Deal) {
        self.deal = deal
        
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subViewFrame: CGRect = CGRectMake(0, 0, self.view!.width * 0.95, self.view!.height * 0.6)
        
        self.scheduleView = ScheduleView(frame: subViewFrame, deal: self.deal!, viewModel: self.viewModel)
        self.scheduleView!.delegate = self

        self.view!.addSubview(self.scheduleView!)
        
        self.scheduleView!.center = CGPointMake(self.view!.width/2, self.view.height/2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:Selector("dismissVC"))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        
        self.view!.addGestureRecognizer(tapGesture)
        
        self.view!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    }
    
    func dismissVC() {
    
        
        self.willMoveToParentViewController(nil)
        
        self.view!.removeFromSuperview()
        
        self.removeFromParentViewController()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view.isDescendantOfView(self.scheduleView!) {
            
            return false
        } else {
            return true
        }
    }

}
