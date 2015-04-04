//
//  LocationTableViewCell.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/1/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

protocol ScheduleReminder {
    func scheduleButtonPressed(sender: UIButton)
}

class LocationTableViewCell: UITableViewCell {
    
    var scheduleButton: UIButton = UIButton()
    
    var delegate:ScheduleReminder?
    
    var cellImageView: UIImageView = UIImageView()
    
    let cellHeight: CGFloat = 150
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.height = cellHeight
        
        let buttonWidth: CGFloat = 100
        
        self.scheduleButton.frame = CGRectMake(0, 0, buttonWidth, self.frame.size.height);
        
        scheduleButton.backgroundColor = UIColor.redColor()
        
        scheduleButton.addTarget(self, action: "scheduleDealDelegate:", forControlEvents:.TouchUpInside)
        
        scheduleButton.setTitle("Schedule", forState: UIControlState.Normal)
        
        self.cellImageView.frame = CGRectMake(0, 0, 144, 102)
        
        self.addSubview(self.cellImageView)
                
        self.addSubview(scheduleButton)
    }
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func scheduleDealDelegate(sender: UIButton) {
        delegate?.scheduleButtonPressed(sender)
    }
    

}
