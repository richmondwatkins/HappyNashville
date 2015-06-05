//
//  DayCollectionViewCell.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/16/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
 
    var dayLabel: UILabel = UILabel()
    var selectedView: UIView = UIView()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        
        self.dayLabel.textColor = UIColor(hexString: StringConstants.navBarTextColor)
        self.addSubview(self.dayLabel)
        self.addSubview(self.selectedView)
        
        self.backgroundColor = UIColor(hexString: StringConstants.primaryColor)
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
