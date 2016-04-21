//
//  LocationSpecialViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/18/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class LocationSpecialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var index: Int = Int()
    var dealDay: DealDay?
    var viewModel:LocationSpecialViewModel = LocationSpecialViewModel()
    var scrollView: UIScrollView?
    var contentHeight: CGFloat = 0
    var top: CGFloat!
    var noDealsView: UILabel = UILabel()
    var collectionView: UICollectionView!
    var cellWidth: CGFloat = 0;
    var dataSource: Array<Special> = []
    let cellHeight: CGFloat = 110
    
    init(dealDay: DealDay, top: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        
        self.top = top
        self.dealDay = dealDay
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self.dealDay!.specials.allObjects as! Array<Special>
        
        self.dataSource = self.dataSource.sort {
            (spec1: Special, spec2: Special) -> Bool in
            return spec1.specialItem < spec2.specialItem
        }
        
        setUpCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        self.collectionView.frame = CGRectMake(0, 5, self.view!.width, self.view!.height)
    }
    
    func setUpCollectionView() {

        self.cellWidth = self.view!.width
        
        let flowLayout: SpecialCollectionFlowLayout = SpecialCollectionFlowLayout(cellWidth:  self.cellWidth, celHeight: cellHeight)
        
        self.collectionView = UICollectionView(frame: self.view!.frame, collectionViewLayout: flowLayout)
        
        self.collectionView.scrollEnabled = true
    
        self.collectionView.registerClass(SpecialCollectionCell.classForCoder(), forCellWithReuseIdentifier: "SpecialCell")
        self.collectionView.bounces = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = .whiteColor()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.view!.addSubview(self.collectionView!)
        
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dealDay!.specials.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var newSize: CGSize = CGSizeZero
        
        if indexPath.row == 0 || indexPath.row % 3 == 0 {
            if indexPath.row  + 2 <= self.dataSource.count - 1 {
                newSize = CGSizeMake(self.view!.width / 3 - 1, self.cellHeight)
            } else if indexPath.row  + 1 <= self.dataSource.count - 1 {
                newSize = CGSizeMake(self.view!.width / 2, self.cellHeight)
            } else {
                newSize = CGSizeMake(self.view!.width, self.cellHeight)
            }
        } else if indexPath.row == 1 || indexPath.row % 2 == 0 && indexPath.row != 2{
            if indexPath.row  + 1 <= self.dataSource.count - 1 {
                newSize = CGSizeMake(self.view!.width / 3 - 1, self.cellHeight)
            } else if indexPath.row  <= self.dataSource.count - 1 {
                newSize = CGSizeMake(self.view!.width / 2, self.cellHeight)
            } else {
                newSize = CGSizeMake(self.view!.width, self.cellHeight)
            }
        } else {
            if indexPath.row <= self.dataSource.count - 1 {
                newSize = CGSizeMake(self.view!.width / 3 - 5, self.cellHeight)
            }
        }
        
        return newSize
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("SpecialCell", forIndexPath: indexPath) as? SpecialCollectionCell
        
        if cell == nil {
            
            cell = SpecialCollectionCell(frame: CGRectMake(0, 0, self.view!.width / 3, 100))
        }
        
        configureCell(cell!, special: self.dataSource[indexPath.row])
        
        return cell!
    }
    
    func configureCell(cell: SpecialCollectionCell, special: Special) {
        // Means its a shot and needs to be smaller
        if special.type.integerValue == 7 {
            cell.typeImageView.frame = CGRectMake(cell.width / 2 - 40, 20, 20, 20)
            
        // Type is well drink and needs to be smaller
        } else if special.type.integerValue == 3 {
            cell.typeImageView.frame = CGRectMake(cell.width / 2 - 40, 15, 30, 30)
        } else {
            cell.typeImageView.frame = CGRectMake(cell.width / 2 - 40, 4, 50, 50)
        }
       
        cell.priceLabel.frame = CGRectMake(0, cell.typeImageView.bottom, cell.width, 15)
        cell.timeLabel.frame = CGRectMake(0, self.cellHeight - 12, cell.width, 10)
        cell.descriptionLabel.frame = CGRectMake(0, cell.priceLabel.bottom + (cell.timeLabel.top - cell.priceLabel.bottom - 30) / 2, cell.width - 10, 30)
        
        cell.descriptionLabel.text = special.specialItem.uppercaseString
        cell.descriptionLabel.center = CGPointMake(cell.width / 2, cell.descriptionLabel.center.y)
        
        cell.typeImageView.center = CGPointMake((cell.width / 2), cell.typeImageView.center.y)
        cell.typeImageView.image = UIImage(named: "special-\(special.type.integerValue)")
        
        cell.priceLabel.text = special.specialPrice
        
        
        cell.timeLabel.text = configureDateString(special)
    }
    
    func configureDateString(special: Special) -> String {
        
        if special.allDay.boolValue {
            return "All Day"
        }
        
        let startDateComponents: NSDateComponents = NSDateComponents()
        startDateComponents.hour = special.hourStart.integerValue
        startDateComponents.minute = special.minuteStart.integerValue
        startDateComponents.timeZone = NSTimeZone(abbreviation: "CT")
        
        let endDateComponents: NSDateComponents = NSDateComponents()
        endDateComponents.hour = special.hourEnd.integerValue
        endDateComponents.minute = special.minuteEnd.integerValue
        endDateComponents.timeZone = NSTimeZone(abbreviation: "CT")
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startTime: NSDate = calendar.dateFromComponents(startDateComponents)!
        let endTime: NSDate = calendar.dateFromComponents(endDateComponents)!
        
        let startDateFormatter: NSDateFormatter = NSDateFormatter()
        startDateFormatter.dateFormat = "h:mm a"
        
        let endDateFormatter: NSDateFormatter = NSDateFormatter()
        endDateFormatter.dateFormat = "h:mm a"
        
        return "\(startDateFormatter.stringFromDate(startTime)) - \(endDateFormatter.stringFromDate(endTime))"
    }
    
    
    
    
    
    
    func createScrollView() {
        for special in self.viewModel.sortSpecialsByTime(self.dealDay!.specials) as! [Special] {
            
            let specialView: LocationSpecialView = LocationSpecialView(special: special, frame: CGRectMake(0, 0, self.view!.width, 0))
            
            specialView.tag = 1

            self.scrollView!.addSubview(specialView)
            
            specialView.top = top
            
            top = specialView.bottom + 10
            
            self.contentHeight += specialView.height + 2
        }
        
        self.scrollView?.contentSize = CGSizeMake(self.view!.width, self.contentHeight + 50)
        self.scrollView?.scrollEnabled = true
    }
    
    func removeAllSpecialView() {
        for view in self.scrollView!.subviews {
            if view.tag == 1 {
                view.removeFromSuperview()
            }
        }
        
        self.scrollView?.contentSize = CGSizeZero
        self.contentHeight = 0
    }
    
    func hideAllSpecials() {
        for view in self.scrollView!.subviews {
            if view.tag == 1 {
                self.view.alpha = 0
            }
        }
    }
    
    func changeDealDay(dealDay: DealDay) {
        self.dealDay = dealDay
        
        let originalCenter = self.scrollView!.center
        self.top = 2

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.noDealsView.alpha = 0
            self.scrollView!.frame = CGRectMake(0, self.view!.bottom * 2, self.scrollView!.width, self.scrollView!.height)
            self.hideAllSpecials()
        }) { (complete) -> Void in
            self.removeAllSpecialView()
            self.createScrollView()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView!.center = originalCenter
                }) { (complete) -> Void in
                    //
            }
        }
    }
    
    func createNoDealsView() {
        noDealsView.frame = CGRectMake(0, 0, self.view!.width, 100)
        noDealsView.textAlignment = .Center
        noDealsView.numberOfLines = 0
        noDealsView.alpha = 0
        self.scrollView!.addSubview(noDealsView)
    }
    
    func showNoDealsView(day: String) {
        noDealsView.text = "There are no deals at \(self.dealDay!.location.name) on \(day)"
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.hideAllSpecials()
            self.noDealsView.alpha = 1
        })
    }

}
