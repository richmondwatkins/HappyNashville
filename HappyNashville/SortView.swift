//
//  SortView.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/20/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class SortView: UIView {
    
    let viewModel: AppViewModel = AppViewModel()
    
    var segmentControl: UISegmentedControl!
    var drinkSortButton: UIButton = UIButton()
    var resetSortButton: UIButton = UIButton()
    var ratingSortButton: UIButton = UIButton()
    var alphaSortButton: UIButton = UIButton()

     init(frame: CGRect, currentSort: String?) {
        super.init(frame: frame)

        self.segmentControl = UISegmentedControl(items: ["Food", "Drink", "Rating", "A-Z", "Day"])
        
        let segHeight = self.height * 0.7
        
        self.segmentControl.frame = CGRectMake(10, (self.height / 2) - (segHeight / 2), self.width - 20, segHeight)
        
        self.segmentControl.tintColor = UIColor(hexString: StringConstants.primaryColor)
        
        if let sort = currentSort {
            
            switch sort {
            case "Food":
                self.segmentControl.selectedSegmentIndex = 0
                break;
            case "Drink":
                self.segmentControl.selectedSegmentIndex = 1
                break;
            case "Rating":
                self.segmentControl.selectedSegmentIndex = 2
                break;
            case "A-Z":
                self.segmentControl.selectedSegmentIndex = 3
                break;
            default:
                break;
            }
        } else {
            self.segmentControl.selectedSegmentIndex = 4
        }
        
        self.addSubview(self.segmentControl)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
