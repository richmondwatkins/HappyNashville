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
        
        self.sortView.segmentControl.addTarget(self, action: "segmentTapped:", forControlEvents: UIControlEvents.ValueChanged)
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissVC")
        tapGesture.numberOfTapsRequired = 1
        
        self.view!.addGestureRecognizer(tapGesture)
    }
    
    func segmentTapped(sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
            case 0:
                foodSort()
                break;
            case 1:
                drinkSort()
                break;
            case 2:
                ratingSort()
                break;
            case 3:
                alphaSort()
                break;
            case 4:
                resetSort()
                break;
            default:
                break;
            
        }
    }
    
    func foodSort() {
        self.delegate?.showFoodOnly("Food")
        dismissVC();
    }
    
    func drinkSort() {
        self.delegate?.showDrinkOnly("Drink")
        dismissVC();
    }
    
    func resetSort() {
        self.delegate?.resetSort("")
        dismissVC();
    }
    
    func ratingSort() {
        self.delegate?.ratingSort("Rating")
        dismissVC();
    }
    
    func alphaSort() {
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
