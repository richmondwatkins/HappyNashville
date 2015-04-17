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
    var buttonView = UIView()
    var containerView = UIView()
    var webSiteButton = UIButton()
    var mapButton = UIButton()
    var typeView = UIView()
    var ratingView = HCSStarRatingView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.layoutMargins = UIEdgeInsetsZero
        
        self.titleLable.frame = CGRectMake(10, 10, self.width, 20)
        self.titleLable.numberOfLines = 0
        self.titleLable.textAlignment = NSTextAlignment.Left
        
        self.backgroundColor = UIColor.clearColor()
        
        self.webSiteButton.setTitle("Website", forState: UIControlState.Normal)
        self.webSiteButton.backgroundColor = UIColor.blueColor()
        self.scheduleButton.backgroundColor = UIColor.redColor()
        self.contentCard.backgroundColor = UIColor.whiteColor()
        self.buttonView.backgroundColor = UIColor.greenColor()
        self.mapButton.setTitle("Map", forState: .Normal)
        self.mapButton.backgroundColor = UIColor.brownColor()

        self.contentCard.layer.masksToBounds = false
        self.contentCard.layer.cornerRadius = 1
        self.contentCard.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        self.contentCard.layer.shadowRadius = 1
        
        var bezierPath: UIBezierPath = UIBezierPath(rect: self.contentCard.bounds)
        self.contentCard.layer.shadowPath = bezierPath.CGPath
        self.contentCard.layer.shadowOpacity = 0.2
        
        self.ratingView.maximumValue = 5
        self.ratingView.minimumValue = 0
        self.ratingView.allowsHalfStars = true
        self.ratingView.userInteractionEnabled = false
        self.ratingView.tintColor = UIColor.redColor()
        
        self.buttonView.addSubview(self.mapButton)
        self.buttonView.addSubview(self.webSiteButton)
        self.buttonView.addSubview(self.scheduleButton)
        
        self.contentCard.addSubview(self.ratingView)
        self.contentCard.addSubview(self.titleLable)
        self.contentCard.addSubview(self.typeView)
        
        self.containerView.addSubview(self.buttonView)
        self.containerView.addSubview(self.contentCard)
        
        self.addSubview(self.containerView)
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
