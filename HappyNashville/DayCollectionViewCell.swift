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
    var dateLabel: UILabel = UILabel()
    var selectedView: UIView = UIView()
    var isCurrentDay: Bool = Bool()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        
        self.addSubview(self.dayLabel)
        self.addSubview(self.dateLabel)
        self.addSubview(self.selectedView)
        
        self.backgroundColor = UIColor.yellowColor()
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
