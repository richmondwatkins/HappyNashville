//
//  FooterViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/7/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

@objc protocol DaySelectionProtocol {
    func slideTableToSection(section: Int)
}

class FooterViewController: UIViewController {

    var viewFrame: CGRect!
    var viewModel: AppViewModel = AppViewModel()
    var delegate: DaySelectionProtocol?
    
    let week: Array<String> = ["S", "M", "T", "W", "T", "F", "S"]
    
    init(viewFrame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewFrame = viewFrame
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view!.frame = self.viewFrame
        self.view!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        let buttonMeasurements = self.viewModel.getButtonWidth(self.view!.width, numberOfButtons: 7, padding: 0)
        
        var left = buttonMeasurements.buttonPadding
        
        var i: Int = 0
        for day in week {
            
            var dayButton:UIButton  = DayButton(frame:
                CGRectMake(CGFloat(left), 0, buttonMeasurements.buttonWidth, self.view!.height))
            
            dayButton.setTitle(day, forState: .Normal)
            dayButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
            dayButton.setTitleColor(UIColor(hexString: StringConstants.primaryColor), forState: .Normal)
            dayButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            dayButton.tag = i
            dayButton.addTarget(self, action: "selecteDay:", forControlEvents: .TouchUpInside)
            left = CGFloat(dayButton.right + buttonMeasurements.buttonPadding)
            
            self.view!.addSubview(dayButton)

            i++
        }
    }
    
    func selecteDay(sender: UIButton) {
        
        self.delegate?.slideTableToSection(sender.tag)
    }

}
