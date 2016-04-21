//
//  DirectionsViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/19/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol UserLocationProtocol {
    func displayUserPinOnMap(coords: CLLocationCoordinate2D)
}

class DirectionsViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    var parentFrame: CGRect = CGRect()
    var containerView: UIView = UIView()
    let location: Location?
    let manager = CLLocationManager()
    var openOutsideMap: Bool = true
    var delegate: UserLocationProtocol?
    var directionsButton: UIButton!
    var showOnMap: UIButton!
    
    init(parentFrame: CGRect, location: Location) {
        
        self.location = location
        self.parentFrame = parentFrame
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.frame = CGRectMake(0, 0, self.parentFrame.size.width * 0.95, self.parentFrame.size.height / 2)
        self.containerView.backgroundColor = .whiteColor()
        self.containerView.center = CGPointMake(self.view!.width / 2, self.view!.height / 2)
        self.containerView.layer.cornerRadius = 5.0
        self.containerView.tag = 1
        
        self.directionsButton = UIButton(frame: CGRectMake(0, 0, self.containerView.width, self.containerView.height / 2))
        self.directionsButton.backgroundColor = UIColor(hexString: StringConstants.navBarTextColor)
        self.directionsButton.setTitle("Get Directions", forState: .Normal)
        self.directionsButton.setTitleColor(UIColor(hexString: StringConstants.primaryColor), forState: .Normal)
        self.directionsButton.addTarget(self, action: "getDirections:", forControlEvents: .TouchUpInside)
        
        self.showOnMap = UIButton(frame: CGRectMake(0, directionsButton.bottom, self.containerView.width, self.containerView.height / 2))
        self.showOnMap.backgroundColor = UIColor(hexString: StringConstants.primaryColor)
        self.showOnMap.setTitle("Show My Location", forState: .Normal)
        self.showOnMap.addTarget(self, action: "showLocationOnMap:", forControlEvents: .TouchUpInside)
        
        self.containerView.addSubview(self.directionsButton)
        self.containerView.addSubview(self.showOnMap)
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("SeenDirections") {
            
            setUpFirstTimeView()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "SeenDirections")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        self.view!.addSubview(self.containerView)
        
        self.view!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissVC")
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapGesture)
        
        self.view!.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view!.alpha = 1
        })
    }
    
    
    func setUpFirstTimeView() {
        
        let dirExplLabel: UILabel = UILabel()
        
        dirExplLabel.text = "Takes you to a map application"
        dirExplLabel.textColor = UIColor(hexString: StringConstants.primaryColor)
        dirExplLabel.textAlignment = .Center
        dirExplLabel.sizeToFit()
        dirExplLabel.font = UIFont.systemFontOfSize(10)
        dirExplLabel.center = CGPointMake(self.directionsButton.width / 2, self.directionsButton.height / 2 + 20)
        
        self.directionsButton.addSubview(dirExplLabel)
        
        let mapExplLabel: UILabel = UILabel()
        mapExplLabel.text = "Keeps you in the app"
        mapExplLabel.textColor = UIColor(hexString: StringConstants.navBarTextColor)
        mapExplLabel.textAlignment = .Center
        mapExplLabel.font = UIFont.systemFontOfSize(10)
        mapExplLabel.sizeToFit()
        
        mapExplLabel.center = CGPointMake(self.showOnMap.width / 2, self.showOnMap.height / 2 + 20)
        
        self.showOnMap.addSubview(mapExplLabel)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view!.tag == 1 {
            return false
        } else {
            return true
        }
    }
    
    func getDirections(sender: UIButton) {
        self.openOutsideMap = true
        findLocation()
    }
    
    func findLocation() {
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            
            self.manager.requestWhenInUseAuthorization()
        } else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
            
            manager.startUpdatingLocation()
        } else {
            //
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        self.manager.stopUpdatingLocation()
        
        if self.openOutsideMap {
            openOutsideMap(coord)
        } else {
            self.delegate?.displayUserPinOnMap(coord)
        }
        dismissVC()
    }
    
    func openOutsideMap(coords: CLLocationCoordinate2D) {
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!) {
            
            UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?saddr=\(coords.latitude),\(coords.longitude)&daddr=\(self.location!.lat.doubleValue),\(self.location!.lng.doubleValue)&center=\(self.location!.lat),\(self.location!.lng)&zoom=10")!)
        } else {
            
            let placeMark: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.location!.lat.doubleValue, longitude: self.location!.lng.doubleValue), addressDictionary: nil)
            
            let destination: MKMapItem = MKMapItem(placemark: placeMark)
            destination.name = self.location!.name
            
            let options = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ]
            
            destination.openInMapsWithLaunchOptions(options)
        }
        
    }
    
    func concatStringWithPlus(string: String) -> String {
        return string.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func showLocationOnMap(sender: UIButton) {
        self.openOutsideMap = false
        findLocation()
    }
    
    func dismissVC() {
        self.willMoveToParentViewController(nil)
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
}