//
//  DetailFlowLayout.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/18/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class WeekFlowLayout: UICollectionViewFlowLayout {
    
    init(cellWidth: CGFloat, celHeight: CGFloat) {
        super.init()
        
        self.itemSize = CGSizeMake(cellWidth, celHeight)
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
