//
//  LocationSpecialPageViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/18/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

protocol PageScrollProtocol {
    func scrollColletionViewToDay(index: Int) -> UIPageViewControllerNavigationDirection?
}

class LocationSpecialPageViewController: UIViewController,  UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageController: UIPageViewController?
    var dealDays: Array<DealDay> = []
    var delegate: PageScrollProtocol?
    var top: CGFloat!
    
    init(dealDays: Array<DealDay>, top: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        
        self.top = top
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
            options: nil
        )
        
        pageController?.delegate = self
        pageController?.dataSource = self
        
        let startingViewController: LocationSpecialViewController = viewControllerAtIndex(0)
        
        let viewControllers: NSArray = [startingViewController]
        self.pageController!.setViewControllers(viewControllers as [AnyObject],
            direction: .Forward,
            animated: false,
            completion: nil)
                
        self.addChildViewController(pageController!)
        self.view.addSubview(self.pageController!.view)
          
        pageController!.didMoveToParentViewController(self)
        
        self.view!.backgroundColor = .whiteColor()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        var vc = viewController as! LocationSpecialViewController
        
        var index = vc.index
        
        if index == 0 {
            return nil
        }
        
        index--

        return viewControllerAtIndex(index)
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
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        var currentPageVC: LocationSpecialViewController = pageViewController.viewControllers.last as! LocationSpecialViewController
        
        self.delegate?.scrollColletionViewToDay(currentPageVC.index)
    }
    
    func viewControllerAtIndex(index: Int) -> LocationSpecialViewController {
        
        var dealDay: DealDay = self.dealDays[index]

        var vc: LocationSpecialViewController = LocationSpecialViewController(dealDay: self.dealDays[index], top: self.top)
        vc.index = index
        
        return vc
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func scrollToDealDayAtIndexPath(indexPath: NSIndexPath, animate: Bool, direction: UIPageViewControllerNavigationDirection) {
        self.pageController!.setViewControllers([viewControllerAtIndex(indexPath.row)], direction: direction, animated: animate, completion: nil)
    }
    
    func scrollToDealDayAtIndexPath(indexPath: NSIndexPath) {
        self.pageController!.setViewControllers([viewControllerAtIndex(indexPath.row)], direction: .Forward, animated: false, completion: nil)
    }

}
