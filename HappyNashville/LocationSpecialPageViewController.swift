//
//  LocationSpecialPageViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/18/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class LocationSpecialPageViewController: UIViewController,  UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageController: UIPageViewController?
    var dealDays: Array<DealDay> = []
    
    init(dealDays: Array<DealDay>) {
        super.init(nibName: nil, bundle: nil)
        
        self.dealDays = dealDays
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController = UIPageViewController(
            transitionStyle: .Scroll,
            navigationOrientation: .Horizontal,
            options: nil)
        
        pageController?.delegate = self
        pageController?.dataSource = self
        
        let startingViewController: LocationSpecialViewController =
        viewControllerAtIndex(0)
        
        let viewControllers: NSArray = [startingViewController]
        pageController!.setViewControllers(viewControllers as [AnyObject],
            direction: .Forward,
            animated: false,
            completion: nil)
        
        self.addChildViewController(pageController!)
        self.view.addSubview(self.pageController!.view)
        
        var pageViewRect = self.view.bounds
        pageController!.view.frame = pageViewRect    
        pageController!.didMoveToParentViewController(self)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        var vc = viewController as! LocationSpecialViewController
        
        if vc.index == 0 {
            return nil
        }
        
        vc.index--
        
        return viewControllerAtIndex(vc.index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! LocationSpecialViewController
        
        var index = vc.index
        
        index++
        
        if index == self.dealDays.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> LocationSpecialViewController {
        
        var vc: LocationSpecialViewController = LocationSpecialViewController(dealDay: self.dealDays[index])
        
        vc.index = index
        
        return vc
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.dealDays.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func scrollToDealDayAtIndexPath(indexPath: NSIndexPath) {
        var vc: LocationSpecialViewController = LocationSpecialViewController(dealDay: self.dealDays[indexPath.row])
        
        self.pageController!.setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }

}
