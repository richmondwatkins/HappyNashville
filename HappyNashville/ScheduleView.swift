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
    func alertTimeIsLessThanCurrent()
}

class ScheduleView: UIView {
    
    var timePicker: UIDatePicker?
    var recurringSwitch: UISwitch?
    var viewModel: ScheduleViewControllerViewModel = ScheduleViewControllerViewModel()
    var dealDay: DealDay?
    var delegate: ScheduleViewProtocol?
    var submitButton: UIButton!
    
    init(frame: CGRect, dealDay: DealDay, viewModel: ScheduleViewControllerViewModel) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let titleLablePadding: CGFloat = 10
        
        self.viewModel = viewModel
        self.dealDay = dealDay
        self.frame = frame
        
        var titleLabel: UILabel = UILabel(
            frame: CGRectMake(
                titleLablePadding,
                titleLablePadding,
                frame.size.width - titleLablePadding,
                10
            )
        );
        
        let dayString = self.viewModel.dayForDayNumber(dealDay.day.integerValue)
        let locationString = dealDay.location.name
        
        let titleString = "Schedule a reminder for \(locationString) on \(dayString) at:"
        
        var attributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: titleString)
        let startOfDay: Int = 24 + count(locationString) + 4
        attributedTitle.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(16)], range: NSRange(location: 24, length: count(locationString)))
        attributedTitle.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(16)], range: NSRange(location: startOfDay, length: count(dayString)))
        
        titleLabel.attributedText = attributedTitle
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.center = CGPointMake(self.width/2, titleLabel.center.y)
        
        self.addSubview(titleLabel)
        
        self.timePicker = UIDatePicker(frame: CGRectMake(0, titleLabel.bottom, frame.width * 0.95, frame.height * 0.4))
        self.timePicker?.datePickerMode = UIDatePickerMode.Time
        self.timePicker?.date = self.viewModel.calculateDatePickerDate(dealDay)
        
        self.addSubview(self.timePicker!)
        
        let buttonPadding: CGFloat = 10
        let buttonHeight: CGFloat = 50
        let buttonY = self.height - buttonHeight - buttonPadding
        
        let buttonDimensons = self.viewModel.getButtonWidth(self.width, numberOfButtons: 2, padding: 6)
        
        submitButton = UIButton(frame:
            CGRectMake(
                buttonDimensons.buttonPadding,
                buttonY,
                buttonDimensons.buttonWidth + (buttonDimensons.buttonWidth * 0.25),
                buttonHeight
            )
        )
        
        submitButton.layer.cornerRadius = 5.0
        submitButton.setTitle("Submit", forState: UIControlState.Normal)
        submitButton.backgroundColor = UIColor(hexString: StringConstants.primaryColor)
        submitButton.addTarget(self, action: "submitSchedule", forControlEvents: UIControlEvents.TouchUpInside)
        
        var cancelButton: UIButton = UIButton(frame:
            CGRectMake(
                submitButton.right + buttonDimensons.buttonPadding,
                buttonY, buttonDimensons.buttonWidth - (buttonDimensons.buttonWidth * 0.25),
                buttonHeight
            )
        )
        
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.backgroundColor = UIColor(hexString: StringConstants.cancelColor)
        cancelButton.addTarget(self, action: "dismissVC:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let controlViewHeight: CGFloat = 40
        
        let switchView: UIView = UIView(frame: CGRectMake(0, submitButton.top - controlViewHeight - 10, frame.size.width, controlViewHeight))
        
        var topBorder: CALayer = CALayer()
        topBorder.frame = CGRectMake(0, 0, switchView.width, 1)
        topBorder.backgroundColor = UIColor(hexString: StringConstants.grayShade).CGColor
        
        var bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRectMake(0, switchView.height, switchView.width, 1);
        bottomBorder.backgroundColor = UIColor(hexString: StringConstants.grayShade).CGColor
        
        switchView.layer.addSublayer(topBorder)
        switchView.layer.addSublayer(bottomBorder)
        
        let switchPadding: CGFloat = 10
        
        let switchLabel: UILabel = UILabel(frame: CGRectMake(switchPadding, 0, 10, controlViewHeight))
        switchLabel.text = "Send weekly reminder"
        switchLabel.sizeToFit()
        switchLabel.center = CGPointMake(switchLabel.center.x, controlViewHeight / 2)
        
        switchView.addSubview(switchLabel)
        
        var controlSwitchWidth: CGFloat = 50
        
        self.recurringSwitch = UISwitch(frame: CGRectMake(switchView.width - controlSwitchWidth - switchPadding, 0, controlSwitchWidth, controlViewHeight))
        self.recurringSwitch!.center = CGPointMake(self.recurringSwitch!.center.x, controlViewHeight / 2)
        
        switchView.addSubview(self.recurringSwitch!)
        
        self.addSubview(cancelButton)
        self.addSubview(submitButton)
        self.addSubview(switchView)
        
    }
    
    func dismissVC(sender: UIButton) {
        self.delegate?.dismissVC()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func submitSchedule() {
        var timePickerDate: NSDate = self.timePicker!.date
        
        if timePickerDate.timeIntervalSince1970 < NSDate().timeIntervalSince1970 {
            let dayComponent: NSDateComponents = NSDateComponents();
            dayComponent.day = 7
            
            let cal: NSCalendar = NSCalendar.currentCalendar();
            timePickerDate = cal.dateByAddingComponents(dayComponent, toDate: timePickerDate, options: nil)!
        }
        
        self.viewModel.scheduleReminder(timePickerDate, isRecurring: self.recurringSwitch!.on, dealDay: self.dealDay!)
        self.delegate?.dismissVC()
    }
    
    
}