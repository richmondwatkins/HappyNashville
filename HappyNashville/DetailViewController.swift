
//
//  DetailViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/1/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DetialViewModelProtocol, PageScrollProtocol {
    
    var location: Location?
    var mapView: MKMapView = MKMapView()
    var collectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var viewModel: DetailViewModel?
    let selectedHeight: CGFloat = 5
    var pageVC: LocationSpecialPageViewController!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(location: Location) {
        super.init(nibName: nil, bundle: nil)
        
        self.location = location
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.backgroundColor = UIColor.whiteColor()
        
        if (self.location != nil) {
            var dealDays: NSSet = self.location!.dealDays
            self.viewModel = DetailViewModel(dealDays:dealDays.allObjects as! Array<DealDay>)
            self.viewModel!.delegate = self
            
            setTitleView()
            setUpMapView()
            setUpCollectionView()
        }
    }
    
    func setUpCollectionView() {
        
        var cellWidth: CGFloat = CGFloat()
        
        if self.location!.dealDays.count < 7 {
            cellWidth = self.view!.width / CGFloat(self.location!.dealDays.count)
        } else {
            cellWidth = 70
        }
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, self.mapView.bottom, self.view!.width, 40), collectionViewLayout: self.flowLayout)
        
        self.collectionView!.registerClass(DayCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CollCell")
        self.collectionView!.setCollectionViewLayout(WeekFlowLayout(cellWidth: cellWidth, celHeight: 40), animated: true)
        self.collectionView!.bounces = true
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = false
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        
        self.view!.addSubview(self.collectionView!)
        
        setUpPageViewController(self.collectionView!.bottom)
        
        self.collectionView!.reloadData()
//        
//        self.collectionView!.scrollToItemAtIndexPath(NSIndexPath(forRow: self.viewModel!.getCurrentDay() - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
         return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.location!.dealDays.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollCell", forIndexPath: indexPath) as? DayCollectionViewCell
        
        if cell == nil {
            
            cell = DayCollectionViewCell(frame: CGRectMake(0, 0, 70, 70))
        }
        
        configureCell(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    func configureCell(cell: DayCollectionViewCell, indexPath: NSIndexPath) {
        
        cell.selectedView.frame = CGRectMake(0, cell.height - self.selectedHeight, cell.width, self.selectedHeight)
        
        self.viewModel!.configureSelected(cell, indexPath: indexPath)
        
        cell.dayLabel.text = self.viewModel!.dayLabelText(self.viewModel!.dataSource[indexPath.row])
        
        cell.dayLabel.font = UIFont.systemFontOfSize(12)
        cell.dayLabel.sizeToFit()
        cell.dayLabel.center = CGPointMake(cell.width / 2, (cell.height * 0.15))
        
        cell.dateLabel.text = self.viewModel!.dateLabelText(indexPath)
        
        cell.dateLabel.font = UIFont.systemFontOfSize(9)
        cell.dateLabel.sizeToFit()
        cell.dateLabel.center = CGPointMake(cell.width / 2, cell.dayLabel.center.y)
        cell.dateLabel.top = cell.dayLabel.bottom + 3
        
        self.viewModel!.dateLabelText(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let scrollDirection = scrollColletionViewToDay(indexPath.row) {
            self.pageVC.scrollToDealDayAtIndexPath(indexPath, animate:true, direction: scrollDirection)
        }
    }
    
    
    func setTitleView() {
        var addressLabel: UILabel = UILabel()
        addressLabel.text = self.location!.address
        addressLabel.font = UIFont.systemFontOfSize(12)
        addressLabel.sizeToFit()
        
        var nameLabel: UILabel = UILabel()
        nameLabel.text = self.location!.name
        nameLabel.sizeToFit()
        
        var titleView: UIView = UIView(frame: CGRectMake(0, 0, addressLabel.width, self.navigationController!.navigationBar.height))
        
        titleView.addSubview(nameLabel)
        titleView.addSubview(addressLabel)
        
        nameLabel.center = CGPointMake(titleView.width / 2, nameLabel.center.y)
        addressLabel.top = nameLabel.bottom
        
        self.navigationItem.titleView = titleView
    }

    func setUpMapView() {
        self.view!.addSubview(self.mapView)
        
        self.mapView.frame = CGRectMake(0, self.navigationController!.navigationBar.bottom, self.view!.width * 0.98, self.view!.height * 0.3)
        
        self.mapView.center = CGPointMake(self.view!.width / 2, self.mapView.center.y)
        
        var coords: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.location!.lat.doubleValue, self.location!.lng.doubleValue)
        
        var locationAnnotation: MKPointAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = coords
        locationAnnotation.title = self.location!.name
        
        var coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: coords, span: coordinateSpan)
        
        self.mapView.addAnnotation(locationAnnotation)
        self.mapView.region = mapRegion
        self.mapView.selectAnnotation(locationAnnotation, animated: true)
    }
    
    func setUpPageViewController(collectionBottom: CGFloat) {
    
        self.pageVC = LocationSpecialPageViewController(dealDays: self.viewModel!.dataSource)
        
        self.pageVC.view!.top = collectionBottom
        
        self.addChildViewController(self.pageVC)
        
        self.view!.addSubview(self.pageVC.view!)
        
        pageVC.didMoveToParentViewController(self)
        
        pageVC.delegate = self
    }
    
    func scrollPageViewControllertoDay(indexPath: NSIndexPath) {
        
        self.pageVC.scrollToDealDayAtIndexPath(indexPath)
    }

    func scrollColletionViewToDay(index: Int) -> UIPageViewControllerNavigationDirection? {
        var cell: DayCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! DayCollectionViewCell
        
        if let scrollDirection = self.viewModel?.setNewSelectedCell(cell, index: index) {
            return scrollDirection
        } else {
            return nil
        }
    }
}
