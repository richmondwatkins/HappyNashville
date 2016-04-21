//
//  ACNativeAdCell.swift
//  ApptlyCore
//
//  Created by Richmond Watkins on 3/13/16.
//  Copyright © 2016 Richmond Watkins. All rights reserved.
//

import UIKit
import mopub_ios_sdk

class ACNativeAdCell: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mainTextLabel: UILabel!
    
    @IBOutlet weak var callToActionButton: UIButton!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var privacyIcon: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        // Decorate the call to action button.
        callToActionButton.layer.masksToBounds = false
        callToActionButton.layer.borderColor = callToActionButton.titleLabel?.textColor.CGColor
        callToActionButton.layer.borderWidth = 2
        callToActionButton.layer.cornerRadius = 6
        
        // Decorate the ad container.
        containerView.layer.cornerRadius = 6
        
        // Add the background color to the main view.
        backgroundColor = UIColor.grayColor()
    }
}

extension ACNativeAdCell: MPNativeAdRendering {
    
    func nativeMainTextLabel() -> UILabel! {
        
        return self.mainTextLabel
    }
    
    func nativeTitleTextLabel() -> UILabel! {
        
        return self.titleLabel
    }
    
    func nativeCallToActionTextLabel() -> UILabel! {
        
        return self.callToActionButton.titleLabel
    }
    
    func nativeIconImageView() -> UIImageView! {
        
        return self.iconImageView
    }
    
    func nativeMainImageView() -> UIImageView! {
        
        return self.mainImageView
    }
    
    func nativeVideoView() -> UIView! {
        
        return self.videoView
    }
    
    func nativePrivacyInformationIconImageView() -> UIImageView! {
        
        return self.privacyIcon
    }
    
    // Return the nib used for the native ad.
    class func nibForAd() -> UINib! {
        
        return UINib(nibName: "ACNativeAdCell", bundle: NSBundle(forClass: ACNativeAdCell.self))
    }
}