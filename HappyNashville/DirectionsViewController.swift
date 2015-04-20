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

class DirectionsViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

    var parentFrame: CGRect = CGRect()
    var containerView: UIView = UIView()
    let location: Location?
    let manager = CLLocationManager()
    
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
        
        var directionsButton: UIButton = UIButton(frame: CGRectMake(0, 0, self.containerView.width, self.containerView.height / 2))
        directionsButton.backgroundColor = .orangeColor()
        directionsButton.setTitle("Get Directions", forState: .Normal)
        directionsButton.addTarget(self, action: "getDirections:", forControlEvents: .TouchUpInside)
        
        var showOnMap: UIButton = UIButton(frame: CGRectMake(0, directionsButton.bottom, self.containerView.width, self.containerView.height / 2))
        showOnMap.backgroundColor = .redColor()
        showOnMap.setTitle("Show my location", forState: .Normal)
        
        self.containerView.addSubview(directionsButton)
        self.containerView.addSubview(showOnMap)
        
        self.view!.addSubview(self.containerView)

        self.view!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissVC")
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        
        self.view!.addGestureRecognizer(tapGesture)
        println("WOO")
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view.tag == 1 {
            return false
        } else {
            return true
        }
    }
    
    func getDirections(sender: UIButton) {
        
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        
        self.manager.stopUpdatingLocation()
        
        displayOnMap(coord)
    }
    
    func displayOnMap(coords: CLLocationCoordinate2D) {
       
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!) {
            
            UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?saddr=\(coords.latitude),\(coords.longitude)&daddr=\(self.location!.lat.doubleValue),\(self.location!.lng.doubleValue)&center=\(self.location!.lat),\(self.location!.lng)&zoom=10")!)
        } else {
            
            var placeMark: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.location!.lat.doubleValue, longitude: self.location!.lng.doubleValue), addressDictionary: nil)
            
            var destination: MKMapItem = MKMapItem(placemark: placeMark)
            destination.name = self.location!.name
            
            var options = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ]
            
            destination.openInMapsWithLaunchOptions(options)
        }
        
    }
    
    func concatStringWithPlus(string: String) -> String {
        return string.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }

    func dismissVC() {
        self.willMoveToParentViewController(nil)
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()
    }

}
