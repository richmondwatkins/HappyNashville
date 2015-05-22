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
    func showFooter()
}

class ScheduleViewController: UIViewController, ScheduleViewProtocol {

    var dealDay: DealDay?
    var scheduleView: ScheduleView?
    var viewModel: ScheduleViewControllerViewModel = ScheduleViewControllerViewModel()
    let navHeight: CGFloat?
    let selectedIndexPath: NSIndexPath?
    var delegate: ScheduleProtocol?
    var specialVC: LocationSpecialViewController!
    
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
        
        addSpecialViewController(self.dealDay!)        
    }
    
    func addSpecialViewController(dealDay: DealDay) {
        specialVC = LocationSpecialViewController(dealDay: self.dealDay!, top: 2)
        specialVC.view!.frame = CGRectMake(
            0,
            self.scheduleView!.timePicker!.bottom - 20,
            self.view!.width,
            self.scheduleView!.recurringSwitch!.superview!.top - self.scheduleView!.timePicker!.bottom + 18
        )
        
        self.addChildViewController(specialVC)
        self.scheduleView!.addSubview(specialVC.view!)
        specialVC.didMoveToParentViewController(self)
    }
    
    func timePickerDidChange() {
        var dealDays: Array<DealDay> = self.dealDay?.location.dealDays.allObjects as! [DealDay]
        let changedToDay: Int = self.viewModel.weekDayForTimePicker(self.scheduleView!.timePicker!.date)
        var foundDealDay: Bool = false
        for deal in dealDays {
            if deal.day.integerValue == changedToDay {
                foundDealDay = true
                specialVC.dealDay = deal
                specialVC.changeDealDay(deal)
            }
        }
        
        if !foundDealDay {
            specialVC.showNoDealsView(self.viewModel.dayForDayNumber(changedToDay))
        }
    }
    
    func alertTimeIsLessThanCurrent() {
        var alert = UIAlertController(title: "Unable To Schedule", message: "An alert cannot be schedule for a date that has already past", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func dismissVC() {
        
        self.willMoveToParentViewController(nil)
        
        let parentVC: ViewController = self.parentViewController! as! ViewController
      
        if self.dealDay!.notification != nil {
            self.delegate!.updateScheduledCell(self.selectedIndexPath!)
        }
        
        parentVC.subView.transformAndRemoveSubview(self.view!, completed: { (result) -> Void in
                        
            self.removeFromParentViewController()
            
            self.delegate?.showFooter()
        })
        
    }

}
