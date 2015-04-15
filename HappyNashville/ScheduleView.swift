//
//  ScheduleView.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/3/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

protocol ScheduleViewProtocol {
    func dismissVC()
}

class ScheduleView: UIView {
    
    var timePicker: UIDatePicker?
    var recurringSwitch: UISwitch?
    var viewModel: ScheduleViewControllerViewModel?
    var deal: Deal?
    var delegate: ScheduleViewProtocol?
    
    init(frame: CGRect, deal: Deal, viewModel: ScheduleViewControllerViewModel) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()

        let titleLablePadding: CGFloat = 10
        
        self.viewModel = viewModel
        self.deal = deal
        self.frame = frame
        
        var titleLabel: UILabel = UILabel(frame: CGRectMake(titleLablePadding, titleLablePadding, frame.size.width - titleLablePadding, 10));
        titleLabel.text = "Schedule a reminder for \(deal.location.name)"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.center = CGPointMake(self.width/2, titleLabel.center.y)
        
        self.addSubview(titleLabel)
        
        self.timePicker = UIDatePicker(frame: CGRectMake(0, titleLabel.bottom, frame.width * 0.95, frame.height * 0.4))
        self.timePicker?.date = self.viewModel!.calculateDatePickerDate(deal)
        self.addSubview(self.timePicker!)
    
        let controlViewHeight: CGFloat = 40
    
        let switchView: UIView = UIView(frame: CGRectMake(0, self.timePicker!.bottom + 10, frame.size.width, controlViewHeight))
        
        var topBorder: CALayer = CALayer()
        topBorder.frame = CGRectMake(0, 0, switchView.width, 1)
        topBorder.backgroundColor = UIColor.grayColor().CGColor
        
        var bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRectMake(0, switchView.height, switchView.width, 1);
        bottomBorder.backgroundColor = UIColor.grayColor().CGColor
        
        switchView.layer.addSublayer(topBorder)
        switchView.layer.addSublayer(bottomBorder)
    
        let switchPadding: CGFloat = 5
        
        let switchLabel: UILabel = UILabel(frame: CGRectMake(switchPadding, 0, 10, controlViewHeight))
        switchLabel.text = "Send weekly reminder"
        switchLabel.sizeToFit()
        switchLabel.center = CGPointMake(switchLabel.center.x, controlViewHeight / 2)
        
        switchView.addSubview(switchLabel)
        
        var controlSwitchWidth: CGFloat = 50
        
        self.recurringSwitch = UISwitch(frame: CGRectMake(switchView.width - controlSwitchWidth - switchPadding, 0, controlSwitchWidth, controlViewHeight))
        self.recurringSwitch!.center = CGPointMake(self.recurringSwitch!.center.x, controlViewHeight / 2)

        switchView.addSubview(self.recurringSwitch!)
        
        let buttonPadding: CGFloat = 10
        
        var submitButton: UIButton = UIButton(frame: CGRectMake(buttonPadding, self.height - 50 - buttonPadding, self.width - (buttonPadding * 2), 50))
        submitButton.layer.cornerRadius = 5.0
        submitButton.setTitle("SUBMIT", forState: UIControlState.Normal)
        submitButton.backgroundColor = UIColor.blueColor()
        submitButton.addTarget(self, action: "submitSchedule", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(submitButton)
    
        self.addSubview(switchView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func submitSchedule() {
        
        self.viewModel?.scheduleReminder(self.timePicker!.date, isRecurring: self.recurringSwitch!.on, deal: self.deal!)
        
        self.delegate?.dismissVC()
    }


}
