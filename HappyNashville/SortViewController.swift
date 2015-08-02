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
    func sortByLocation(navTitle: String)
    func retrieveLocations() -> Array<Location> 
    func nullifySortVC()
}

class SortViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var delegate: SortProtocol?
    var sortView: SortView!
    var currentSort: String?
    var navHeight: CGFloat!
    
    init(sortTitle: String?, navBottom: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        
        self.currentSort = sortTitle
        self.navHeight = navBottom
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.view!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        let sortViewHeight: CGFloat = self.view!.height * 0.1
        
        self.view!.frame = CGRectMake(0, self.navHeight, self.view!.width, self.view!.height - self.navHeight)
        
        self.sortView = SortView(frame: CGRectMake(0, self.view!.height - sortViewHeight, self.view!.width, sortViewHeight), currentSort: self.currentSort)
        self.sortView.backgroundColor = .whiteColor()
        self.sortView.tag = 1
        
        self.view!.addSubview(self.sortView)
        
        self.sortView.segmentControl.addTarget(self, action: "segmentTapped:", forControlEvents: UIControlEvents.ValueChanged)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissVC")
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        
        self.view!.addGestureRecognizer(tapGesture)
    }
    
    func segmentTapped(sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
            case 0:
                sortByVicinity()
                break;
            case 1:
                foodSort()
                break;
            case 2:
                drinkSort()
                break;
            case 3:
                resetSort()
                break;
            case 4:
                displaySearch()
                break;
            default:
                break;
        }
    }
    
    func displaySearch() {
        let searchVC: SearchViewController = SearchViewController(
            viewFrame: CGRectMake(
                0,
                0,
                self.view!.width,
                self.view!.height / 2
            ),
            locations: self.delegate!.retrieveLocations()
        )
        searchVC.view.tag = 1
        self.view!.addSubview(searchVC.view)
        self.addChildViewController(searchVC)
        searchVC.didMoveToParentViewController(self)
    }
    
    func sortByVicinity() {
        self.delegate?.sortByLocation("Distance")
        dismissVC()
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view.tag == 1 {
            return false
        } else {
            return true
        }
    }
    
    func dismissVC() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view!.alpha = 0
        }) { (complete) -> Void in
            self.willMoveToParentViewController(nil)
            self.view!.removeFromSuperview()
            self.removeFromParentViewController()
            
            self.delegate?.nullifySortVC()
        }

    }
}
