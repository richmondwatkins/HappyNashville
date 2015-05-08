//
//  DayButton.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/7/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class DayButton: UIButton {

    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            if newValue {
                backgroundColor = UIColor(hexString: StringConstants.primaryColor)
            }
            else {
                backgroundColor = UIColor.whiteColor()
            }
            super.highlighted = newValue
        }
    }
}
