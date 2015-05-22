//
//  MapViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/15/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UserLocationProtocol, MKMapViewDelegate {
    
    var location: Location?
    var locations: Array<Location>!
    var mapView: MKMapView = MKMapView()
    var viewModel: MapViewModel = MapViewModel()
    var twelveSouthPoly: Array<CLLocationCoordinate2D> = []
    var downTownPolyArray: Array<CLLocationCoordinate2D> = []
    var eastNashvillePolyArray: Array<CLLocationCoordinate2D> = []
    var germantownPolyArray: Array<CLLocationCoordinate2D> = []
    var gulchPolyArray: Array<CLLocationCoordinate2D> = []
    
    init(location: Location, locations: Array<Location>) {
        self.locations = locations
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
        self.mapView.delegate = self
        
        self.view!.addSubview(self.mapView)
        
        var locationAnnotation = createAnnotation(self.location!)
        
        var coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: locationAnnotation.coordinate, span: coordinateSpan)
        
        self.mapView.addAnnotation(locationAnnotation)
        self.mapView.region = mapRegion
        self.mapView.selectAnnotation(locationAnnotation, animated: true)
        
        for location in self.locations {
            
            self.mapView.addAnnotation(createAnnotation(location))
        }
        
        var findMe : UIBarButtonItem = UIBarButtonItem(title: "Find Me", style: UIBarButtonItemStyle.Plain, target: self, action: "showDirectionsPopUp:")
        
        self.navigationItem.rightBarButtonItem = findMe
        
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        
        createTwelveSouthPolyArray()
        createDownTownPolyArray()
        createEastNashvillePolyArray()
        createGermantownPolyArray()
        createGulchPolyArray()
    }
    
    func createGulchPolyArray() {
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.155912, -86.788945))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.157420, -86.785405))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.155063, -86.783774))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.154353, -86.782422))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.149311, -86.775341))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.149155, -86.779268))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.150073, -86.783688))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.150628, -86.784718))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.153452, -86.787486))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.155652, -86.788645))
        self.gulchPolyArray.append(CLLocationCoordinate2DMake(36.155878, -86.788924))
        
        let gulchPolygon: GulchPolygon = GulchPolygon(coordinates: &self.gulchPolyArray, count: self.gulchPolyArray.count)
        
        self.mapView.addOverlay(gulchPolygon)
    }
    
    func createGermantownPolyArray() {
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.178897, -86.794965))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.180543, -86.791317))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.182171, -86.789021))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.180560, -86.787991))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.181045, -86.787004))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.178326, -86.785245))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.175312, -86.783657))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.174359, -86.787133))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.174238, -86.787455))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.173251, -86.791360))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.173736, -86.791489))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.175122, -86.792519))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.176057, -86.793163))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.176819, -86.793592))
        self.germantownPolyArray.append(CLLocationCoordinate2DMake(36.178863, -86.795008))
        
        let germantownPolygon: GermantownPolygon = GermantownPolygon(coordinates: &self.germantownPolyArray, count: self.germantownPolyArray.count)
        
        self.mapView.addOverlay(germantownPolygon)
    }
    
    func createEastNashvillePolyArray() {
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.206286, -86.776221))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.203654, -86.738541))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.222560, -86.726010))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.233915, -86.724722))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.234676, -86.713393))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.230245, -86.711762))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.217618, -86.707375))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.194071, -86.691839))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.191646, -86.691238))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.189291, -86.691839))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.179832, -86.702647))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.172696, -86.708312))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.167361, -86.716123))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.165143, -86.725736))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.163965, -86.739554))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.160847, -86.751742))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.159669, -86.763587))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.162233, -86.771226))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.163480, -86.772857))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.176085, -86.779568))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.176916, -86.772530))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.182181, -86.774933))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.189317, -86.775878))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.194165, -86.775448))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.201715, -86.776650))
        self.eastNashvillePolyArray.append(CLLocationCoordinate2DMake(36.206286, -86.776307))
        
        let eastNashvillePolygon: EastNashvillePolygon = EastNashvillePolygon(coordinates: &self.eastNashvillePolyArray, count: self.eastNashvillePolyArray.count)
        
        self.mapView.addOverlay(eastNashvillePolygon)
    }
    
    func createDownTownPolyArray() {
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.171487, -86.798611))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.174258, -86.787281))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.174605, -86.786509))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.174605, -86.786509))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.172006, -86.779642))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.168369, -86.777110))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.168369, -86.777110))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.158390, -86.766167))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.158390, -86.766167))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.157004, -86.760416))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.156277, -86.760588))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.155411, -86.761446))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.153886, -86.763678))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.149346, -86.774407))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.148896, -86.777067))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.148965, -86.779814))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.149138, -86.781273))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.149138, -86.781273))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.150698, -86.785307))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.151634, -86.786423))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.156207, -86.789470))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.160296, -86.792774))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.161682, -86.793289))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.164315, -86.793847))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.166013, -86.794749))
        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.171452, -86.798568))
        
        let downtownPolygon: DowntownPolygon = DowntownPolygon(coordinates: &self.downTownPolyArray, count: self.downTownPolyArray.count)
        
        self.mapView.addOverlay(downtownPolygon)
    }
    
    func createTwelveSouthPolyArray() {
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.135918, -86.791910))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.135814, -86.786889))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.133873, -86.787232))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.133527, -86.785687))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.127911, -86.786031))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.127565, -86.783155))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.127045, -86.783155))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.127322, -86.786117))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.126560, -86.786245))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.126456, -86.785602))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.126074, -86.785645))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.125936, -86.783370))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.120216, -86.783842))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.120181, -86.783885))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.119869, -86.787275))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.119869, -86.787275))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.116853, -86.787104))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.117616, -86.797017))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.119869, -86.795429))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.121395, -86.794785))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.126733, -86.793927))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.127738, -86.794313))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.128050, -86.793713))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.127946, -86.792511))
        self.twelveSouthPoly.append(CLLocationCoordinate2DMake(36.135918, -86.791910))
        
        let twelveSouthPolygon: TwelveSouthPolygon = TwelveSouthPolygon(coordinates: &self.twelveSouthPoly, count: self.twelveSouthPoly.count)
        
        self.mapView.addOverlay(twelveSouthPolygon)
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
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        var pr = MKPolygonRenderer(overlay: overlay);
        pr.lineWidth = 5;

        if (overlay is TwelveSouthPolygon) {
            pr.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.2);
            
            return pr;
        } else if overlay is DowntownPolygon {
            pr.strokeColor = UIColor.greenColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.greenColor().colorWithAlphaComponent(0.2);
            
            return pr
        } else if overlay is EastNashvillePolygon {
            pr.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.redColor().colorWithAlphaComponent(0.2);
            
            return pr
        } else if overlay is GermantownPolygon {
            pr.strokeColor = UIColor.orangeColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.orangeColor().colorWithAlphaComponent(0.2);
            
            return pr
        } else if overlay is GulchPolygon {
            pr.strokeColor = UIColor.purpleColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.2);
            
            return pr
        }
        
        return nil
    }

}
