
//
//  SpecialCollectionCellCollectionViewCell.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/17/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class SpecialCollectionCell: UICollectionViewCell {
    
    var typeImageView: UIImageView = UIImageView()
    var priceLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    var timeLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        priceLabel.font = UIFont.systemFontOfSize(11)
        priceLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel.font = UIFont.systemFontOfSize(11)
        descriptionLabel.textAlignment = .Center
        timeLabel.font = UIFont.systemFontOfSize(10)
        timeLabel.textAlignment = .Center
        
        typeImageView.contentMode = UIViewContentMode.ScaleAspectFit;
        
        self.addSubview(typeImageView)
        self.addSubview(priceLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(timeLabel)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
