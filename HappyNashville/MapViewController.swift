//
//  MapViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/15/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UserLocationProtocol {
    
    var location: Location?
    var mapView: MKMapView = MKMapView()
    var viewModel: MapViewModel = MapViewModel()
    
    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.backgroundColor = UIColor.whiteColor()
        self.mapView.frame = self.view!.frame
        
        self.view!.addSubview(self.mapView)
        
        var locationAnnotation = createAnnotation(self.location!)
        
        var coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: locationAnnotation.coordinate, span: coordinateSpan)
        
        self.mapView.addAnnotation(locationAnnotation)
        self.mapView.region = mapRegion
        self.mapView.selectAnnotation(locationAnnotation, animated: true)
        
        for location in self.viewModel.locations {
            
            self.mapView.addAnnotation(createAnnotation(location))
        }
        
        var findMe : UIBarButtonItem = UIBarButtonItem(title: "Find Me", style: UIBarButtonItemStyle.Plain, target: self, action: "showDirectionsPopUp:")
        
        self.navigationItem.rightBarButtonItem = findMe
    }
    
    func showDirectionsPopUp(sender: UIButton) {
        
        var directionsVC: DirectionsViewController = DirectionsViewController(parentFrame: self.view!.frame, location:  self.location!)
        
        directionsVC.delegate = self
        
        self.addChildViewController(directionsVC)
        
        self.view!.addSubview(directionsVC.view)
        
        directionsVC.didMoveToParentViewController(self)
    }
    
    func createAnnotation(location: Location) -> MKPointAnnotation {
        var locationAnnotation: MKPointAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = CLLocationCoordinate2DMake(location.lat.doubleValue, location.lng.doubleValue)
        locationAnnotation.title = location.name
        
        return locationAnnotation
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
