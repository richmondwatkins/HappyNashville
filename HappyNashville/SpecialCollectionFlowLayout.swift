//
//  SpecialCollectionFlowLayout.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/17/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class SpecialCollectionFlowLayout: UICollectionViewFlowLayout {
   
    init(cellWidth: CGFloat, celHeight: CGFloat) {
        super.init()
        
        self.itemSize = CGSizeMake(cellWidth, celHeight)
        self.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 5
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
