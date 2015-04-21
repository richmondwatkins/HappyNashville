//
//  SortViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/20/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

protocol SortProtocol {
    func showFoodOnly()
    func showDrinkOnly()
    func resetSort()
    func ratingSort()
}

class SortViewController: UIViewController {
    
    var delegate: SortProtocol?

    var sortView: SortView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.view!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        let sortViewHeight: CGFloat = self.view!.height * 0.1
        
        self.sortView = SortView(frame: CGRectMake(0, self.view!.height - sortViewHeight, self.view!.width, sortViewHeight))
        self.sortView.backgroundColor = .whiteColor()
        
        self.view!.addSubview(self.sortView)
        
        self.sortView.foodSortButton.addTarget(self, action: "foodSort:", forControlEvents: .TouchUpInside)
        self.sortView.drinkSortButton.addTarget(self, action: "drinkSort:", forControlEvents: .TouchUpInside)
        self.sortView.resetSortButton.addTarget(self, action: "resetSort:", forControlEvents: .TouchUpInside)
        self.sortView.ratingSortButton.addTarget(self, action: "ratingSort:", forControlEvents: .TouchUpInside)
    }
    
    func foodSort(sender: UIButton) {
        self.delegate?.showFoodOnly()
        dismissVC();
    }
    
    func drinkSort(sender: UIButton) {
        self.delegate?.showDrinkOnly()
        dismissVC();
    }
    
    func resetSort(sender: UIButton) {
        self.delegate?.resetSort()
        dismissVC();
    }
    
    func ratingSort(sender: UIButton) {
        self.delegate?.ratingSort()
        dismissVC();
    }
    
    func dismissVC() {
        self.willMoveToParentViewController(nil)
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
