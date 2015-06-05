//
//  LocationTableViewCell.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/1/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

protocol LocationCellProtocol {
    func scheduleButtonPressed(sender: UIButton)
}

class LocationTableViewCell: UITableViewCell {
    
    var scheduleButton: UIButton = UIButton()
    var titleLable: UILabel = UILabel()
    var delegate:LocationCellProtocol?
    var contentCard = UIView()
    var buttonView = UIView()
    var containerView = UIView()
    var webSiteButton = UIButton()
    var mapButton = UIButton()
    var typeView = UIView()
    var ratingView = HCSStarRatingView()
    var notifImageView: UIImageView = UIImageView()
    var distanceLabel: UILabel = UILabel()
    var buttonLayer: CALayer!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.layoutMargins = UIEdgeInsetsZero
        
        self.notifImageView.image = UIImage(named: "bell")
        self.notifImageView.hidden = true
        self.titleLable.frame = CGRectMake(10, 10, self.width, 20)
        self.titleLable.textAlignment = NSTextAlignment.Left
        self.titleLable.font = UIFont(name: "GillSans", size: 16)
        self.titleLable.numberOfLines = 1
        self.webSiteButton.setImage(UIImage(named: "share"), forState: .Normal)
        self.mapButton.setImage(UIImage(named: "map"), forState: .Normal)
        
        setUpButtons([self.webSiteButton, self.mapButton, self.scheduleButton])
        
        self.contentCard.backgroundColor = UIColor.whiteColor()
        self.buttonView.backgroundColor = .whiteColor()
        
        self.buttonLayer = buttonViewLayer(buttonView.width)
        self.buttonView.layer.addSublayer(self.buttonLayer)

        self.contentCard.layer.masksToBounds = false
        self.contentCard.layer.cornerRadius = 2
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
        
        self.distanceLabel.font = UIFont.systemFontOfSize(10)
        self.distanceLabel.textColor = UIColor(hexString: "a8a8a8")
        
        self.contentCard.addSubview(self.notifImageView)
        self.contentCard.addSubview(self.titleLable)
        self.contentCard.addSubview(self.typeView)
        
        self.containerView.addSubview(self.buttonView)
        self.containerView.addSubview(self.contentCard)
        
        self.buttonView.addSubview(self.distanceLabel)
        self.buttonView.addSubview(self.ratingView)
  
        self.backgroundColor = UIColor(hexString: StringConstants.grayShade)
        self.addSubview(self.containerView)
    }
    
    func buttonViewLayer(width: CGFloat) -> CALayer {
        var newLayer: CALayer = CALayer()
        newLayer.frame = CGRectMake(0, 0, width, 1)
        newLayer.backgroundColor = UIColor(hexString: StringConstants.primaryColor).CGColor
        
        return newLayer
    }
    
    func setUpButtons(buttons: Array<UIButton>) {
        for button in buttons {
            button.backgroundColor = .whiteColor()
            self.buttonView.addSubview(button)
        }
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