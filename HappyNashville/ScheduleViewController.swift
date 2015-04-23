//
//  ScheduleViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/3/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

protocol ScheduleProtocol {
    func updateScheduledCell(indexPath: NSIndexPath)
}

class ScheduleViewController: UIViewController, ScheduleViewProtocol {

    var dealDay: DealDay?
    var scheduleView: ScheduleView?
    var viewModel: ScheduleViewControllerViewModel = ScheduleViewControllerViewModel()
    let navHeight: CGFloat?
    let selectedIndexPath: NSIndexPath?
    var delegate: ScheduleProtocol?
    
    init(dealDay: DealDay, navHeight: CGFloat, indexPath: NSIndexPath) {
        self.dealDay = dealDay
        self.navHeight = navHeight
        self.selectedIndexPath = indexPath
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.backgroundColor = UIColor.whiteColor()

        let scheduleViewFrame = CGRectMake(0, self.navHeight!, self.view!.width, self.view!.height - self.navHeight!)
        
        self.scheduleView = ScheduleView(frame: scheduleViewFrame, dealDay: self.dealDay!, viewModel: self.viewModel)
        self.scheduleView!.delegate = self

        self.view!.addSubview(self.scheduleView!)
                
    }
    
    func dismissVC() {
        
        self.willMoveToParentViewController(nil)
        
        let parentVC: ViewController = self.parentViewController! as! ViewController
      
        if self.dealDay!.notification != nil {
            self.delegate!.updateScheduledCell(self.selectedIndexPath!)
        }
        
        parentVC.subView.transformAndRemoveSubview(self.view!, completed: { (result) -> Void in
            
            parentVC.navigationItem.rightBarButtonItem!.title = "Sort"
            
            self.removeFromParentViewController()
        })
        
    }

}
