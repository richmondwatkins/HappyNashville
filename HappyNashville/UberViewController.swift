//
//  UberViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 8/30/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
@IBDesignable
class UberViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var dealDay: DealDay?
    let locationManager = CLLocationManager()

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var uberButton: UIButton!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var toMapView: MKMapView!
    @IBOutlet weak var fromMapView: MKMapView!
    
    var userCoordinates: CLLocationCoordinate2D? {
        didSet {
            self.reverseGeoCode(userCoordinates!, forPickup: true)
        }
    }
    var destinationCoordinates: CLLocationCoordinate2D? {
        didSet {
            self.reverseGeoCode(destinationCoordinates!, forPickup: false)
        }
    }
    
    init(dealDay: DealDay?) {
        super.init(nibName: "UberViewController", bundle: NSBundle.mainBundle())
        
        self.dealDay = dealDay
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uberButton.backgroundColor = UIColor(hexString: StringConstants.primaryColor)
                
        setToMap()
        setToTextField()
        requestUserLocation()
    }

    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.toTextField.resignFirstResponder()
        self.fromTextField.resignFirstResponder()
    }

    @IBAction func openInUber(sender: UIButton) {
        let uberUrlString: String = "uber://?client_id=UEhtA9cBDRVCOCaT3_mH6M4bPBpj0GcB&action=setPickup&pickup[latitude]=\(self.userCoordinates!.latitude)&pickup[longitude]=\(self.userCoordinates!.longitude)&dropoff[latitude]=\(self.destinationCoordinates!.latitude)&dropoff[longitude]=\(self.destinationCoordinates!.longitude)"
                
        UIApplication.sharedApplication().openURL(NSURL(string: uberUrlString)!)
    }

    @IBAction func textFieldEditingEnded(textField: UITextField) {
        let isFromMap: Bool = (textField === self.fromTextField) ? true : false
        
        self.coordinatesForAddress(textField.text, complete: { (coords: CLLocationCoordinate2D?) -> Void in
            if isFromMap {
                self.setNewLocationFromMap(coords)
            } else {
                self.setNewLocationToMap(coords)
            }
        })
    }
    
    @IBAction func toTextViewDidBeginEditing(sender: AnyObject) {
        
        self.topConstraint.constant -= 10
    }
    
    @IBAction func fromMapDidPan(sender: UIPanGestureRecognizer) {
        
        var didFinish: Bool = false
        
        if sender.state == UIGestureRecognizerState.Ended {
            didFinish = true
        }
        
        keepFromMapPinCenter(didFinish)
    }
    
    @IBAction func toMapDidPan(sender: UIPanGestureRecognizer) {
        
        var didFinish: Bool = false
        
        if sender.state == UIGestureRecognizerState.Ended {
            didFinish = true
        }
        
        keepToMapPinCenter(didFinish)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let isFromMap: Bool = (textField === self.fromTextField) ? true : false
        
        self.coordinatesForAddress(textField.text, complete: { (coords: CLLocationCoordinate2D?) -> Void in
            if isFromMap {
               self.setNewLocationFromMap(coords)
            } else {
                self.setNewLocationToMap(coords)
                self.topConstraint.constant += 10
            }
        })
        
        return true
    }
    
    func setToTextField() {
        if let dealDay = self.dealDay {
            self.toTextField.text = dealDay.location.address
        }
    }
    
    func requestUserLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let defaultCoords: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 36.1667, longitude: -86.7833)
        reverseGeoCode(defaultCoords, forPickup: true)
        setFromMap(defaultCoords)
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            
            self.locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
            
            locationManager.startUpdatingLocation()
        } else {
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coords = locationObj.coordinate
        
        self.locationManager.stopUpdatingLocation()
        
        reverseGeoCode(coords, forPickup: true)
        setFromMap(coords)
        
        self.userCoordinates = coords
    }
    
    func reverseGeoCode(coords: CLLocationCoordinate2D, forPickup: Bool) {
        
        let location: CLLocation = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error == nil) {
                    let placeMark: CLPlacemark = placemarks.first as! CLPlacemark
                    let address: [String]? = placeMark.addressDictionary["FormattedAddressLines"] as? [String]
                    
                    if let address = address {
                        if forPickup {
                            self.fromTextField.text = " ".join(address)
                        } else {
                            self.toTextField.text = " ".join(address)
                        }
                    }
                }
        })
    }
    
    
    func coordinatesForAddress(address: String, complete:(CLLocationCoordinate2D?) -> Void) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if (error == nil) {
                let placeMark: CLPlacemark? = placemarks.first as? CLPlacemark
                
                if let placemark = placeMark {
                    complete(placemark.location.coordinate)
                } else {
                    complete(nil)
                }
            }
        })
    }
    
    @IBAction func dismissVC(sender: UIButton) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.alpha = 0
            }) { (completed) -> Void in
                self.willMoveToParentViewController(self.parentViewController)
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
                let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                userDefaults.setBool(true, forKey: "Push"); userDefaults.synchronize()
        }

    }

}

extension UberViewController: MKMapViewDelegate {
    
    func setToMap() {
        let location: Location = self.dealDay!.location
        
        let locationAnnotation: MKPointAnnotation = createAnnotation(
            CLLocationCoordinate2DMake(location.lat.doubleValue, location.lng.doubleValue)
        )
        
        self.destinationCoordinates = locationAnnotation.coordinate
        
        self.toMapView.addAnnotation(locationAnnotation)
        
        setMapCenter(locationAnnotation.coordinate, mapView: self.toMapView)
    }
    
    func setNewLocationToMap(coords: CLLocationCoordinate2D?) {
        if let coords = coords {
            setMapCenter(coords, mapView: self.toMapView)
            
            let annotation: MKPointAnnotation = self.toMapView.annotations.first as! MKPointAnnotation
            
            annotation.coordinate = coords
            
            self.destinationCoordinates = coords
        }
    }
    
    func setNewLocationFromMap(coords: CLLocationCoordinate2D?) {
        if let coords = coords {
            setMapCenter(coords, mapView: self.fromMapView)
            
            let annotation: MKPointAnnotation = self.fromMapView.annotations.first as! MKPointAnnotation
            
            annotation.coordinate = coords
            
            self.userCoordinates = coords
        }
    }
    
    func keepFromMapPinCenter(didFinish: Bool) {
        let annotation: MKPointAnnotation = self.fromMapView.annotations.first as! MKPointAnnotation

        annotation.coordinate = self.fromMapView.centerCoordinate
        
        if didFinish {
            self.userCoordinates = annotation.coordinate
        }
    }
    
    func keepToMapPinCenter(didFinish: Bool) {
        let annotation: MKPointAnnotation = self.toMapView.annotations.first as! MKPointAnnotation

        annotation.coordinate = self.toMapView.centerCoordinate
        
        if didFinish {
            self.destinationCoordinates = annotation.coordinate
        }
    }
    
    func setFromMap(coordinate: CLLocationCoordinate2D) {
        let locationAnnotation: MKPointAnnotation = createAnnotation(coordinate)
        
        self.userCoordinates = locationAnnotation.coordinate
        
        if self.fromMapView.annotations.count != 0 {
            let existingAnnt: MKPointAnnotation = self.fromMapView.annotations.first as! MKPointAnnotation
            self.fromMapView.removeAnnotation(existingAnnt)
        }
        
        self.fromMapView.addAnnotation(locationAnnotation)
        
        setMapCenter(locationAnnotation.coordinate, mapView: self.fromMapView)
    }
    
    func createAnnotation(coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        var locationAnnotation: MKPointAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = coordinate
        
        return locationAnnotation
    }
    
    func setMapCenter(coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        var coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: coordinateSpan)
        mapView.region = mapRegion
    }
}

extension UberViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
