//
//  SortViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/20/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

protocol SortProtocol {
    func showFoodOnly(navTitle: String)
    func showDrinkOnly(navTitle: String)
    func resetSort(navTitle: String)
    func ratingSort(navTitle: String)
    func alphaSort(navTitle: String)
}

class SortViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var delegate: SortProtocol?

    var sortView: SortView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.view!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        let sortViewHeight: CGFloat = self.view!.height * 0.1
        
        self.sortView = SortView(frame: CGRectMake(0, self.view!.height - sortViewHeight, self.view!.width, sortViewHeight))
        self.sortView.backgroundColor = .whiteColor()
        self.sortView.tag = 1
        
        self.view!.addSubview(self.sortView)
        
        self.sortView.foodSortButton.addTarget(self, action: "foodSort:", forControlEvents: .TouchUpInside)
        self.sortView.drinkSortButton.addTarget(self, action: "drinkSort:", forControlEvents: .TouchUpInside)
        self.sortView.resetSortButton.addTarget(self, action: "resetSort:", forControlEvents: .TouchUpInside)
        self.sortView.ratingSortButton.addTarget(self, action: "ratingSort:", forControlEvents: .TouchUpInside)
        self.sortView.alphaSortButton.addTarget(self, action: "alphaSort:", forControlEvents: .TouchUpInside)
        
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissVC")
        tapGesture.numberOfTapsRequired = 1
        
        self.view!.addGestureRecognizer(tapGesture)
    }
    
    func foodSort(sender: UIButton) {
        self.delegate?.showFoodOnly("Food")
        dismissVC();
    }
    
    func drinkSort(sender: UIButton) {
        self.delegate?.showDrinkOnly("Drink")
        dismissVC();
    }
    
    func resetSort(sender: UIButton) {
        self.delegate?.resetSort("")
        dismissVC();
    }
    
    func ratingSort(sender: UIButton) {
        self.delegate?.ratingSort("Rating")
        dismissVC();
    }
    
    func alphaSort(sender: UIButton) {
        self.delegate?.alphaSort("A-Z")
        dismissVC();
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view.tag == 1 {
            return false
        } else {
            return true
        }
    }
    
    func dismissVC() {
        self.willMoveToParentViewController(nil)
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
