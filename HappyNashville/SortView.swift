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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttonMeasurements = self.viewModel.getButtonWidth(self.width, numberOfButtons: 4)
        
        self.foodSortButton.setImage(UIImage(named: "food"), forState: .Normal)
        self.drinkSortButton.setImage(UIImage(named: "alcohol"), forState: .Normal)
        self.resetSortButton.setTitle("Reset", forState: .Normal)
        self.ratingSortButton.setTitle("Rating", forState: .Normal)
        
        self.resetSortButton.backgroundColor = .blueColor()
        self.ratingSortButton.backgroundColor = .greenColor()
        
        self.foodSortButton.frame = CGRectMake(0, 0, buttonMeasurements.buttonWidth, self.height)
        self.drinkSortButton.frame = CGRectMake(self.foodSortButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, self.height)
        self.resetSortButton.frame = CGRectMake(self.drinkSortButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, self.height)
        self.ratingSortButton.frame = CGRectMake(self.resetSortButton.right + buttonMeasurements.buttonPadding, 0, buttonMeasurements.buttonWidth, self.height)
       
        self.addSubview(self.ratingSortButton)
        self.addSubview(self.resetSortButton)
        self.addSubview(self.drinkSortButton)
        self.addSubview(self.foodSortButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
