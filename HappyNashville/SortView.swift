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
    
    var foodSortButton: UIButton = UIButton()
    var drinkSortButton: UIButton = UIButton()
    var resetSortButton: UIButton = UIButton()
    var ratingSortButton: UIButton = UIButton()
    var alphaSortButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttonMeasurements = self.viewModel.getButtonWidth(self.width, numberOfButtons: 5)
        
        self.foodSortButton.setImage(UIImage(named: "food"), forState: .Normal)
        self.drinkSortButton.setImage(UIImage(named: "alcohol"), forState: .Normal)
        self.resetSortButton.setTitle("Reset", forState: .Normal)
        self.ratingSortButton.setImage(UIImage(named: "rating"), forState: .Normal)
        self.alphaSortButton.setImage(UIImage(named: "a-z"), forState: .Normal)
        self.resetSortButton.setImage(UIImage(named: "reset"), forState: .Normal)
        
        self.foodSortButton.frame = CGRectMake(0, 0, buttonMeasurements.buttonWidth, self.height)
        self.drinkSortButton.frame = CGRectMake(self.foodSortButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, self.height)
        self.ratingSortButton.frame = CGRectMake(self.drinkSortButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, self.height)
        self.alphaSortButton.frame = CGRectMake(self.ratingSortButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, self.height)
        self.resetSortButton.frame = CGRectMake(self.alphaSortButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, self.height)
       
        self.addSubview(self.alphaSortButton)
        self.addSubview(self.ratingSortButton)
        self.addSubview(self.resetSortButton)
        self.addSubview(self.drinkSortButton)
        self.addSubview(self.foodSortButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
