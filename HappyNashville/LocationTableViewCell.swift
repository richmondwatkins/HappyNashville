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
    var titleLable: UILabel = UILabel()
    var delegate:ScheduleReminder?
    var contentCard = UIView()
    var webSiteButton = UIButton()
    var typeView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let buttonWidth: CGFloat = 100
        
        let buttonHeight: CGFloat = 30
        
        self.layoutMargins = UIEdgeInsetsZero
        
        self.titleLable.frame = CGRectMake(10, 10, self.width, 20)
        self.titleLable.numberOfLines = 0
        self.titleLable.textAlignment = NSTextAlignment.Left
        
        self.backgroundColor = UIColor.clearColor()
        
        self.webSiteButton.setTitle("Website", forState: UIControlState.Normal)
        self.webSiteButton.backgroundColor = UIColor.blueColor()
        self.scheduleButton.backgroundColor = UIColor.redColor()
        self.contentCard.backgroundColor = UIColor.whiteColor()
        
        self.contentCard.addSubview(self.titleLable)
        self.contentCard.addSubview(self.webSiteButton)
        self.contentCard.addSubview(self.scheduleButton)
        self.contentCard.addSubview(self.typeView)
        
        self.addSubview(self.contentCard)
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
