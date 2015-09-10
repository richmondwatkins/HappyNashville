//
//  LocationTableViewCell.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/1/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

protocol LocationCellProtocol {
    func webSiteButtonPressed(sender: UIButton)
    func mapButtonPressed(sender: UIButton)
}

class LocationTableViewCell: UITableViewCell {
    
    var scheduleButton: UIButton = UIButton()
    var delegate:LocationCellProtocol?
    var contentCard: LocationCellSpecialView = LocationCellSpecialView()
    var buttonView = UIView()
    var containerView = UIView()
    var webSiteButton = UIButton()
    var mapButton = UIButton()
    var uberButton: UIButton?
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
        self.webSiteButton.setImage(UIImage(named: "share"), forState: .Normal)
        self.mapButton.setImage(UIImage(named: "map"), forState: .Normal)
        
        setUpButtons([self.webSiteButton, self.mapButton, self.scheduleButton])
        
//        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "uber://")!) {
            self.uberButton = UIButton()
            self.uberButton?.setImage(UIImage(named: "uber"), forState: .Normal)
            self.buttonView.addSubview(self.uberButton!)
            self.uberButton!.adjustsImageWhenHighlighted = true
//        }
        
        self.webSiteButton.addTarget(self, action: "websiteDelegate:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapButton.addTarget(self, action: "mapDelegate:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.contentCard.backgroundColor = UIColor.whiteColor()
        self.buttonView.backgroundColor = .whiteColor()
        
        self.buttonLayer = buttonViewLayer(buttonView.width)
        self.buttonView.layer.addSublayer(self.buttonLayer)

        self.contentCard.layer.masksToBounds = false
        self.contentCard.layer.cornerRadius = 2
        self.contentCard.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        self.contentCard.layer.shadowRadius = 1
        
        let bezierPath: UIBezierPath = UIBezierPath(rect: self.contentCard.bounds)
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
        
        self.containerView.addSubview(self.buttonView)
        self.containerView.addSubview(self.contentCard)
        
        self.buttonView.addSubview(self.distanceLabel)
        self.buttonView.addSubview(self.ratingView)
  
        self.backgroundColor = UIColor(hexString: StringConstants.grayShade)
        self.addSubview(self.containerView)        
    }
    
    func setSpecialViewDealDay(dealDay: DealDay) {
        self.contentCard.dealDay = dealDay;
    }
    
    func buttonViewLayer(width: CGFloat) -> CALayer {
        let newLayer: CALayer = CALayer()
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
    
    func websiteDelegate(sender: UIButton) {
        delegate?.webSiteButtonPressed(sender)
    }
    
    func mapDelegate(sender: UIButton) {
        delegate?.mapButtonPressed(sender)
    }
    
    func reDisplay() {
        self.contentCard.setNeedsDisplay()
    }
}