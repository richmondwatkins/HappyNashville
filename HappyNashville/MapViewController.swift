//
//  MapViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/15/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var location: Location?
    var mapView: MKMapView = MKMapView()
    
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
        
        var coords: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.location!.lat.doubleValue, self.location!.lng.doubleValue)
        
        var locationAnnotation: MKPointAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = coords
        locationAnnotation.title = self.location!.name
        
        var coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: coords, span: coordinateSpan)
        
        self.mapView.addAnnotation(locationAnnotation)
        self.mapView.region = mapRegion
        self.mapView.selectAnnotation(locationAnnotation, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
