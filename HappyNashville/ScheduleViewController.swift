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
    let navHeight: CGFloat?
    
    init(deal: Deal, navHeight: CGFloat) {
        self.deal = deal
        self.navHeight = navHeight
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.backgroundColor = UIColor.whiteColor()

        let scheduleViewFrame = CGRectMake(0, self.navHeight!, self.view!.width, self.view!.height - self.navHeight!)
        
        self.scheduleView = ScheduleView(frame: scheduleViewFrame, deal: self.deal!, viewModel: self.viewModel)
        self.scheduleView!.delegate = self

        self.view!.addSubview(self.scheduleView!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:Selector("dismissVC"))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        
        self.view!.addGestureRecognizer(tapGesture)
        
    }
    
    func dismissVC() {
        
        self.willMoveToParentViewController(nil)
        
        let parentVC: ViewController = self.parentViewController! as ViewController
        
        parentVC.subView.transformAndRemoveSubview(self.view!, completed: { (result) -> Void in
            
            self.removeFromParentViewController()
        })
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view.isDescendantOfView(self.scheduleView!) {
            
            return false
        } else {
            return true
        }
    }

}
