
//
//  DetailViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/1/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DetialViewModelProtocol, PageScrollProtocol, UserLocationProtocol {
    
    var location: Location?
    var mapView: MKMapView = MKMapView()
    var collectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var viewModel: DetailViewModel?
    let selectedHeight: CGFloat = 2
    var pageVC: LocationSpecialPageViewController!
    var tabButtonView: LocationTabButtonView?
    
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
            setUpTabButtonView()
            setUpPageViewController()
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: StringConstants.navBarTextColor)
    }
    
    func setUpTabButtonView() {
        
        self.tabButtonView = LocationTabButtonView(frame: CGRectMake(0, self.view!.bottom - 40, self.view!.width, 40))

        let buttonMeasurements = self.viewModel!.getButtonWidth(self.view!.width, numberOfButtons: CGFloat(3), padding: 1)
        
        self.tabButtonView?.websiteButton.frame = CGRectMake(0, 0, buttonMeasurements.buttonWidth, self.tabButtonView!.height)
        self.tabButtonView?.websiteButton.addTarget(self, action: "showWebsite:", forControlEvents: .TouchUpInside)
        
        self.tabButtonView?.phoneButton.frame = CGRectMake(
            self.tabButtonView!.websiteButton.right + buttonMeasurements.buttonPadding,
            0,
            buttonMeasurements.buttonWidth,
            self.tabButtonView!.height
        )
        self.tabButtonView?.phoneButton.addTarget(self, action: "callLocation:", forControlEvents: .TouchUpInside)

        self.tabButtonView?.directionsButton.frame = CGRectMake(
            self.tabButtonView!.phoneButton.right + buttonMeasurements.buttonPadding,
            0, buttonMeasurements.buttonWidth + 3,
            self.tabButtonView!.height
        )
        self.tabButtonView?.directionsButton.addTarget(self, action: "showDirectionsPopUp:", forControlEvents: .TouchUpInside)
        
        self.view!.addSubview(self.tabButtonView!)
    }
    
    func setUpCollectionView() {
        
        var cellWidth: CGFloat = CGFloat()
        
        if self.location!.dealDays.count <= 5 {
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
        
        self.collectionView!.reloadData()
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
        cell.dayLabel.center = CGPointMake(cell.width / 2, cell.height / 2)
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
        addressLabel.textColor = UIColor(hexString: StringConstants.navBarTextColor)
        addressLabel.sizeToFit()
        
        var nameLabel: UILabel = UILabel()
        nameLabel.text = self.location!.name
        nameLabel.textColor = UIColor(hexString: StringConstants.navBarTextColor)
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
    
    func setUpPageViewController() {
    
        self.pageVC = LocationSpecialPageViewController(dealDays: self.viewModel!.dataSource, top: 20)
        
        self.pageVC.view!.height = self.collectionView!.bottom - self.tabButtonView!.top
        
        self.pageVC.view!.top = self.collectionView!.bottom
        
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
    
    func showWebsite(sender: UIButton) {
        
        let webViewController: LocationWebViewController = LocationWebViewController(location: self.viewModel!.dataSource[0].location, navBarHeight: self.navigationController!.navigationBar.height + UIApplication.sharedApplication().statusBarFrame.height)
        
        self.presentViewController(webViewController, animated: true, completion: nil)
    }
    
    func callLocation(sender: UIButton) {
        
        let location: Location = self.viewModel!.dataSource[0].location

        let phoneNumber = location.phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        let phoneURL = NSURL(string: "tel://\(phoneNumber)")!
        
        if UIApplication.sharedApplication().canOpenURL(phoneURL) {
            UIApplication.sharedApplication().openURL(phoneURL)
        } else {
            let alert: UIAlertView = UIAlertView(title: "Error", message: "Your call could not be made at this time", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    func showDirectionsPopUp(sender: UIButton) {
        
        var directionsVC: DirectionsViewController = DirectionsViewController(parentFrame: self.view!.frame, location:  self.viewModel!.dataSource[0].location)
        
        directionsVC.delegate = self
        
        self.addChildViewController(directionsVC)
        
        self.view!.addSubview(directionsVC.view)
        
        directionsVC.didMoveToParentViewController(self)
    }
    
    func displayUserPinOnMap(coords: CLLocationCoordinate2D) {
        
        self.mapView.setUserTrackingMode(MKUserTrackingMode.None, animated: true)
        self.mapView.showsUserLocation = true
        
        var userPoint = MKMapPointForCoordinate(coords)
        var annotationPoint = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: self.location!.lat.doubleValue, longitude: self.location!.lng.doubleValue))
        
        var userRect = MKMapRect(origin: userPoint, size: MKMapSize(width: 0, height: 0))
        
        var annotationRect = MKMapRect(origin: annotationPoint, size: MKMapSize(width: 0, height: 0))

        var unionRect = MKMapRectUnion(userRect, annotationRect)
        
        var fittedRect = self.mapView.mapRectThatFits(unionRect)
 
        self.mapView.setVisibleMapRect(unionRect, animated: true)
                
    }

}
