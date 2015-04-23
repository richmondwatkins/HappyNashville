//
//  LocationTabButtonView.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/19/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class LocationTabButtonView: UIView {
    
    var phoneButton: UIButton = UIButton()
    var websiteButton: UIButton = UIButton()
    var directionsButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.phoneButton.setTitle("Phone", forState: .Normal)
        self.websiteButton.setTitle("Web", forState: .Normal)
        self.directionsButton.setTitle("Directions", forState: .Normal)
        
        configButtons([self.phoneButton, self.websiteButton, self.directionsButton])
        
        self.backgroundColor = UIColor(hexString: StringConstants.primaryColor)
    }
    
    func configButtons(buttons: Array<UIButton>) {
        
        for button in buttons {
            button.backgroundColor = UIColor(hexString: StringConstants.grayShade)
            button.setTitleColor(UIColor(hexString: StringConstants.primaryColor), forState: .Normal)
            self.addSubview(button)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
