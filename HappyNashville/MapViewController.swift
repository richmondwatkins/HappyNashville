//
//  MapViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/15/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UserLocationProtocol, MKMapViewDelegate, MapFilterProtocol {
    
    var location: Location?
    var locations: Array<Location>!
    var mapView: MKMapView = MKMapView()
    var viewModel: MapViewModel = MapViewModel()
    var twelveSouthPoly: Array<CLLocationCoordinate2D> = []
    var downTownPolyArray: Array<CLLocationCoordinate2D> = []
    var eastNashvillePolyArray: Array<CLLocationCoordinate2D> = []
    var germantownPolyArray: Array<CLLocationCoordinate2D> = []
    var gulchPolyArray: Array<CLLocationCoordinate2D> = []
    var filterVC: MapFilterViewController!
    var isFilterOpen: Bool = false
    var twelveSouthPolygon: TwelveSouthPolygon!
    var downtownPolygon: DowntownPolygon!
    var germantownPolygon: GermantownPolygon!
    var eastNashvillePolygon: EastNashvillePolygon!
    var gulchPolygon: GulchPolygon!
    var hillsboroPolygon: HillsboroVillagePolygon!
    var midTownPolygon: MidtownPolygon!
    var musicRowPolyon: MusicRowPolygon!
    var sobroPolygon: SobroPolygon!
    var greenhillsPolygon: GreenHillsPolygon!
    var allOverlays: Array<MKOverlay>?
    var isFirstLoad: Bool = true
    let containerView: UIView = UIView()

    init(location: Location?, locations: Array<Location>) {
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
        
        self.view.addSubview(self.containerView)
        
        self.containerView.frame = self.view.frame
        self.containerView.addSubview(self.mapView)
        
        if let loc = self.location {
            var locationAnnotation = createAnnotation(self.location!)

            self.mapView.addAnnotation(locationAnnotation)
            self.mapView.selectAnnotation(locationAnnotation, animated: true)
            self.setMapCenter(locationAnnotation.coordinate)
        }
        
        setAllAnnotations()
        
        var findMe : UIBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "showFilterVC:")
        
        self.navigationItem.rightBarButtonItem = findMe
        
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        
        setUpSideMenu()
        
        createTwelveSouthPolyArray()
        createDownTownPolyArray()
        createEastNashvillePolyArray()
        createGermantownPolyArray()
        createGulchPolyArray()
        createHillsboroPolygon()
        createMidTownPolygon()
        createMusicRowPloygon()
        createSobroPolygon()
        createGreenHillsPolygon()
    }
    
    func setMapCenter(coordinate: CLLocationCoordinate2D) {
        var coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: coordinateSpan)
        self.mapView.region = mapRegion
    }
    
    func setAllAnnotations() {
        for location in self.locations {
            self.mapView.addAnnotation(createAnnotation(location))
        }
        
        if self.location == nil {
            self.setMapCenter(CLLocationCoordinate2D(latitude: 36.1667, longitude: -86.7833))
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if isFilterOpen {
            self.mapView.frame = CGRectMake(
                self.filterVC.view.width,
                self.mapView.frame.origin.y,
                self.view.width - self.filterVC.view.width,
                self.mapView.height
            )
        } else {
            self.containerView.frame = self.view.frame
        }
        
    }
    
    func createGreenHillsPolygon() {
        var greenHillsArr: Array<CLLocationCoordinate2D> = [
            CLLocationCoordinate2DMake(36.136792, -86.821764),
            CLLocationCoordinate2DMake(36.124037, -86.812495),
            CLLocationCoordinate2DMake(36.122858, -86.806401),
            CLLocationCoordinate2DMake(36.121749, -86.803482),
            CLLocationCoordinate2DMake(36.120362, -86.802023),
            CLLocationCoordinate2DMake(36.117242, -86.799448),
            CLLocationCoordinate2DMake(36.116480, -86.798418),
            CLLocationCoordinate2DMake(36.116202, -86.783570),
            CLLocationCoordinate2DMake(36.111765, -86.782626),
            CLLocationCoordinate2DMake(36.110378, -86.782926),
            CLLocationCoordinate2DMake(36.110482, -86.783527),
            CLLocationCoordinate2DMake(36.108506, -86.785115),
            CLLocationCoordinate2DMake(36.105524, -86.784986),
            CLLocationCoordinate2DMake(36.103721, -86.785286),
            CLLocationCoordinate2DMake(36.100253, -86.787175),
            CLLocationCoordinate2DMake(36.100253, -86.787175),
            CLLocationCoordinate2DMake(36.097445, -86.786402),
            CLLocationCoordinate2DMake(36.088185, -86.787775),
            
            CLLocationCoordinate2DMake(36.090960, -86.818803),
            CLLocationCoordinate2DMake(36.091341, -86.819490),
            CLLocationCoordinate2DMake(36.091515, -86.832279),
            CLLocationCoordinate2DMake(36.092763, -86.839703),
            CLLocationCoordinate2DMake(36.092902, -86.847042),
            CLLocationCoordinate2DMake(36.103617, -86.843737),
            CLLocationCoordinate2DMake(36.103790, -86.844424),
            CLLocationCoordinate2DMake(36.110066, -86.843007),
            CLLocationCoordinate2DMake(36.115405, -86.842879),
            CLLocationCoordinate2DMake(36.115335, -86.843823),
            CLLocationCoordinate2DMake(36.117381, -86.843480),
            CLLocationCoordinate2DMake(36.118976, -86.844424),
            CLLocationCoordinate2DMake(36.121160, -86.848544),
            CLLocationCoordinate2DMake(36.122858, -86.848930),
            CLLocationCoordinate2DMake(36.123343, -86.849574),
            CLLocationCoordinate2DMake(36.127503, -86.843909),
            CLLocationCoordinate2DMake(36.129999, -86.838630),
            CLLocationCoordinate2DMake(36.135267, -86.823524),
            CLLocationCoordinate2DMake(36.136723, -86.821764),
            
        ]
        
        greenhillsPolygon = GreenHillsPolygon(coordinates: &greenHillsArr, count: greenHillsArr.count)
        
        self.mapView.addOverlay(greenhillsPolygon)
    }
    
    func createSobroPolygon() {
        var sobroArr: Array<CLLocationCoordinate2D> = [
            CLLocationCoordinate2DMake(36.156709, -86.783801),
            CLLocationCoordinate2DMake(36.157835, -86.781462),
            CLLocationCoordinate2DMake(36.158806, -86.782106),
            CLLocationCoordinate2DMake(36.160486, -86.778436),
            CLLocationCoordinate2DMake(36.159429, -86.777707),
            CLLocationCoordinate2DMake(36.161300, -86.773158),
            CLLocationCoordinate2DMake(36.159966, -86.769961),
            CLLocationCoordinate2DMake(36.159273, -86.770111),
            CLLocationCoordinate2DMake(36.158234, -86.771784),
            CLLocationCoordinate2DMake(36.157090, -86.774531),
            CLLocationCoordinate2DMake(36.153296, -86.772171),
            CLLocationCoordinate2DMake(36.152638, -86.773823),
            CLLocationCoordinate2DMake(36.153296, -86.775711),
            CLLocationCoordinate2DMake(36.151823, -86.775668),
            CLLocationCoordinate2DMake(36.151841, -86.778994),
            CLLocationCoordinate2DMake(36.153729, -86.781719),
            CLLocationCoordinate2DMake(36.154232, -86.782256),
            CLLocationCoordinate2DMake(36.156727, -86.783801)
        ]
        
        sobroPolygon = SobroPolygon(coordinates: &sobroArr, count: sobroArr.count)
        
        self.mapView.addOverlay(sobroPolygon)
    }
    
    func createMidTownPolygon() {
        var midTownArry: Array<CLLocationCoordinate2D> = [
            CLLocationCoordinate2DMake(36.153070, -86.822290),
            CLLocationCoordinate2DMake(36.154699, -86.818385),
            CLLocationCoordinate2DMake(36.155496, -86.813192),
            CLLocationCoordinate2DMake(36.157540, -86.809716),
            CLLocationCoordinate2DMake(36.157055, -86.803150),
            CLLocationCoordinate2DMake(36.160485, -86.793709),
            CLLocationCoordinate2DMake(36.151441, -86.786842),
            CLLocationCoordinate2DMake(36.151719, -86.789846),
            CLLocationCoordinate2DMake(36.149362, -86.790233),
            CLLocationCoordinate2DMake(36.149536, -86.793365),
            CLLocationCoordinate2DMake(36.136978, -86.796097),
            CLLocationCoordinate2DMake(36.136908, -86.798200),
            CLLocationCoordinate2DMake(36.137497, -86.800217),
            CLLocationCoordinate2DMake(36.138849, -86.812706),
            CLLocationCoordinate2DMake(36.143909, -86.816740),
            CLLocationCoordinate2DMake(36.144706, -86.816268),
            CLLocationCoordinate2DMake(36.146058, -86.813950),
            CLLocationCoordinate2DMake(36.146370, -86.821460),
            CLLocationCoordinate2DMake(36.153058, -86.822319)
        ]
        
        midTownPolygon = MidtownPolygon(coordinates: &midTownArry, count: midTownArry.count)
        
        self.mapView.addOverlay(midTownPolygon)
    }
    
    func createMusicRowPloygon() {
        var musicRowArr: Array<CLLocationCoordinate2D> = [
            CLLocationCoordinate2DMake(36.154104, -86.790147),
            CLLocationCoordinate2DMake(36.153082, -86.789503),
            CLLocationCoordinate2DMake(36.152999, -86.789589),
            CLLocationCoordinate2DMake(36.152146, -86.788988),
            CLLocationCoordinate2DMake(36.151929, -86.789460),
            CLLocationCoordinate2DMake(36.151791, -86.789508),
            CLLocationCoordinate2DMake(36.151656, -86.789503),
            CLLocationCoordinate2DMake(36.148568, -86.790034),
            CLLocationCoordinate2DMake(36.148676, -86.790919),
            CLLocationCoordinate2DMake(36.143274, -86.791949),
            CLLocationCoordinate2DMake(36.143274, -86.791949),
            CLLocationCoordinate2DMake(36.139140, -86.793324),
            CLLocationCoordinate2DMake(36.139720, -86.796447),
            CLLocationCoordinate2DMake(36.143663, -86.795738),
            CLLocationCoordinate2DMake(36.144074, -86.799853),
            CLLocationCoordinate2DMake(36.148653, -86.799123),
            CLLocationCoordinate2DMake(36.153201, -86.794027),
            CLLocationCoordinate2DMake(36.152699, -86.793609),
            CLLocationCoordinate2DMake(36.154111, -86.790143)
        ]
        
        musicRowPolyon = MusicRowPolygon(coordinates: &musicRowArr, count: musicRowArr.count)
        
        self.mapView.addOverlay(musicRowPolyon)
    }
    
    func createHillsboroPolygon() {
         var hillsboroArr: Array<CLLocationCoordinate2D> = [
            CLLocationCoordinate2DMake(36.136522, -86.795174),
            CLLocationCoordinate2DMake(36.136175, -86.794445),
            CLLocationCoordinate2DMake(36.136054, -86.793501),
            CLLocationCoordinate2DMake(36.135959, -86.793404),
            CLLocationCoordinate2DMake(36.135967, -86.791977),
            CLLocationCoordinate2DMake(36.135855, -86.790888),
            CLLocationCoordinate2DMake(36.136158, -86.789901),
            CLLocationCoordinate2DMake(36.136149, -86.788903),
            CLLocationCoordinate2DMake(36.134858, -86.789097),
            CLLocationCoordinate2DMake(36.133221, -86.788785),
            CLLocationCoordinate2DMake(36.132753, -86.788592),
            CLLocationCoordinate2DMake(36.131730, -86.788807),
            CLLocationCoordinate2DMake(36.130812, -86.788764),
            CLLocationCoordinate2DMake(36.128659, -86.789093),
            CLLocationCoordinate2DMake(36.127584, -86.789093),
            CLLocationCoordinate2DMake(36.126345, -86.789297),
            CLLocationCoordinate2DMake(36.125686, -86.789286),
            CLLocationCoordinate2DMake(36.124525, -86.789490),
            CLLocationCoordinate2DMake(36.123433, -86.789812),
            CLLocationCoordinate2DMake(36.121544, -86.790005),
            CLLocationCoordinate2DMake(36.120703, -86.790434),
            CLLocationCoordinate2DMake(36.117921, -86.791335),
            CLLocationCoordinate2DMake(36.116326, -86.791700),
            CLLocationCoordinate2DMake(36.116240, -86.795788),
            CLLocationCoordinate2DMake(36.116439, -86.797998),
            CLLocationCoordinate2DMake(36.116647, -86.798642),
            CLLocationCoordinate2DMake(36.118060, -86.800605),
            CLLocationCoordinate2DMake(36.120365, -86.802064),
            CLLocationCoordinate2DMake(36.120894, -86.802482),
            CLLocationCoordinate2DMake(36.121500, -86.803233),
            CLLocationCoordinate2DMake(36.121873, -86.803866),
            CLLocationCoordinate2DMake(36.122757, -86.806280),
            CLLocationCoordinate2DMake(36.123450, -86.806205),
            CLLocationCoordinate2DMake(36.125348, -86.805379),
            CLLocationCoordinate2DMake(36.126345, -86.804499),
            CLLocationCoordinate2DMake(36.127350, -86.803577),
            CLLocationCoordinate2DMake(36.127948, -86.803298),
            CLLocationCoordinate2DMake(36.128251, -86.802997),
            CLLocationCoordinate2DMake(36.129178, -86.802697),
            CLLocationCoordinate2DMake(36.130262, -86.801882),
            CLLocationCoordinate2DMake(36.131284, -86.801485),
            CLLocationCoordinate2DMake(36.131683, -86.801517),
            CLLocationCoordinate2DMake(36.133147, -86.801313),
            CLLocationCoordinate2DMake(36.134716, -86.799199),
            CLLocationCoordinate2DMake(36.135080, -86.798287),
            CLLocationCoordinate2DMake(36.135305, -86.797064),
            CLLocationCoordinate2DMake(36.136553, -86.795187),
        ]
        
        hillsboroPolygon = HillsboroVillagePolygon(coordinates: &hillsboroArr, count: hillsboroArr.count)
        
        self.mapView.addOverlay(hillsboroPolygon)
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
        
        gulchPolygon = GulchPolygon(coordinates: &self.gulchPolyArray, count: self.gulchPolyArray.count)
        
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
        
        germantownPolygon = GermantownPolygon(coordinates: &self.germantownPolyArray, count: self.germantownPolyArray.count)
        
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
        
        eastNashvillePolygon = EastNashvillePolygon(coordinates: &self.eastNashvillePolyArray, count: self.eastNashvillePolyArray.count)
        
        self.mapView.addOverlay(eastNashvillePolygon)
    }
    
    func createDownTownPolyArray() {
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.171487, -86.798611))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.175783, -86.781531))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.172076, -86.779599))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.161751, -86.773463))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.158356, -86.766124))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.158304, -86.760352))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.156970, -86.760416))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.156346, -86.760588))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.155203, -86.761768))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.153834, -86.763871))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.149381, -86.774214))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.149294, -86.774922))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.154544, -86.782089))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.155220, -86.783247))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.157663, -86.784814))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.155844, -86.789170))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.160036, -86.792517))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.161110, -86.793118))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.164125, -86.793762))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.165545, -86.794405))
//        self.downTownPolyArray.append(CLLocationCoordinate2DMake(36.171435, -86.798611))
        
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
        
        downtownPolygon = DowntownPolygon(coordinates: &self.downTownPolyArray, count: self.downTownPolyArray.count)
        
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
        
        self.twelveSouthPolygon = TwelveSouthPolygon(coordinates: &self.twelveSouthPoly, count: self.twelveSouthPoly.count)
        
        
        self.mapView.addOverlay(twelveSouthPolygon)
    }
    
    func setUpSideMenu() {
        
        let navHeight: CGFloat = self.navigationController!.navigationBar.height + UIApplication.sharedApplication().statusBarFrame.size.height
        
        self.filterVC = MapFilterViewController(
            viewFrame: CGRectMake(
                self.view!.width,
                navHeight,
                70,
                self.view!.height - navHeight
            )
        )
        
        self.filterVC.delegate = self
        
        self.addChildViewController(filterVC)
        self.view.addSubview(self.filterVC.view!)
        filterVC.didMoveToParentViewController(self)
    }
    
    func showFilterVC(sender: UIButton) {
        
        if self.isFilterOpen {
            closeSidemenu()
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.containerView.frame = CGRectMake(
                    -(self.filterVC.view.width),
                    self.view.frame.origin.y,
                    self.view.width,
                    self.view.height
                )
                
                self.filterVC.view.frame = CGRectMake(
                    self.view.width - self.filterVC.view.width,
                    self.filterVC.view.frame.origin.y,
                    self.filterVC.view.width,
                    self.filterVC.view.height
                )
                
                self.mapView.frame = CGRectMake(
                    self.filterVC.view.width,
                    self.mapView.frame.origin.y,
                    self.view.width - self.filterVC.view.width,
                    self.mapView.height
                )
                
                }) { (complete) -> Void in
                    self.isFilterOpen = true
            }
        }
    }
    
    func closeSidemenu() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.containerView.frame = CGRectMake(
                0,
                self.view.frame.origin.y,
                self.view.width,
                self.view.height
            )
            
            self.filterVC.view.frame = CGRectMake(
                self.view!.width,
                self.filterVC.view.frame.origin.y,
                self.filterVC.view.width,
                self.filterVC.view.height
            )
            
            self.mapView.frame = CGRectMake(
                0,
                self.mapView.frame.origin.y,
                self.containerView.width,
                self.mapView.height
            )
            
            }) { (complete) -> Void in
                self.isFilterOpen = false
        }
    }
    
    func filterDowntown(shouldHide: Bool) {
        runFilter(self.downtownPolygon, shouldHide: shouldHide)
    }
    
    func filterTwelveSouth(shouldHide: Bool) {
        runFilter(self.twelveSouthPolygon, shouldHide: shouldHide)
    }
    
    func filterGermantown(shouldHide: Bool) {
        runFilter(self.germantownPolygon, shouldHide: shouldHide)
    }
    
    func filterEastNashville(shouldHide: Bool) {
        runFilter(self.eastNashvillePolygon, shouldHide: shouldHide)
    }
    
    func filterGulch(shouldHide: Bool) {
        runFilter(self.gulchPolygon, shouldHide: shouldHide)
    }
    
    func filterHillsboro(shouldHide: Bool) {
        runFilter(self.hillsboroPolygon, shouldHide: shouldHide)
    }
    
    func filterMidtown(shouldHide: Bool) {
        runFilter(self.midTownPolygon, shouldHide: shouldHide)
    }
    
    func filterMusicRow(shouldHide: Bool) {
        runFilter(self.musicRowPolyon, shouldHide: shouldHide)
    }
    
    func filterSobro(shouldHide: Bool) {
        runFilter(self.sobroPolygon, shouldHide: shouldHide)
    }
    
    func filterGreenHills(shouldHide: Bool) {
        runFilter(self.greenhillsPolygon, shouldHide: shouldHide)
    }
    
    func resetAll() {
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)

        for annotation in self.mapView.annotations as! [MKPointAnnotation] {
            
            self.mapView.viewForAnnotation(annotation).hidden = false
        }
        
        if let overlayArr = self.allOverlays {
            for mkOverlay in overlayArr {
                self.mapView.addOverlay(mkOverlay)
            }
        }
    }
    
    func runFilter(overlay: MKOverlay, shouldHide: Bool) {
        
        for annotation in self.mapView.annotations as! [MKPointAnnotation] {

            let mapPoint:MKMapPoint = MKMapPointForCoordinate(annotation.coordinate);
            
            var polygonView = MKPolygonRenderer(overlay: overlay);
            
            let polyPoint = polygonView.pointForMapPoint(mapPoint)
        
            var shouldHide: Bool = true
            
            if CGPathContainsPoint(polygonView.path, nil, polyPoint, false) {
                shouldHide = false
            }
            
            if self.mapView.viewForAnnotation(annotation) != nil {
                self.mapView.viewForAnnotation(annotation).hidden = shouldHide
            }
        }

        if let overlayArr = self.allOverlays {
            for mkOverlay in overlayArr {
                if mkOverlay.coordinate.latitude != overlay.coordinate.latitude {
                    self.mapView.removeOverlay(mkOverlay)
                } else {
                    self.mapView.addOverlay(mkOverlay)
                    self.mapView.setCenterCoordinate(mkOverlay.coordinate, animated: true)
                }
            }
        }
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
            pr.strokeColor = UIColor(hexString: StringConstants.twelveSouthColor).colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor(hexString: StringConstants.twelveSouthColor).colorWithAlphaComponent(0.2);
            
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
        } else if overlay is HillsboroVillagePolygon {
            pr.strokeColor = UIColor.cyanColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.cyanColor().colorWithAlphaComponent(0.2);
            
            return pr
        } else if overlay is MidtownPolygon {
            pr.strokeColor = UIColor.brownColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.brownColor().colorWithAlphaComponent(0.2);
            
            return pr
        } else if overlay is MusicRowPolygon {
            pr.strokeColor = UIColor.grayColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.grayColor().colorWithAlphaComponent(0.2);
            
            return pr
        } else if overlay is SobroPolygon {
            pr.strokeColor = UIColor.magentaColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.magentaColor().colorWithAlphaComponent(0.2);
            
            return pr
        } else if overlay is GreenHillsPolygon {
            pr.strokeColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5);
            
            pr.fillColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.2);
            
            return pr
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
        }
        
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        for location in self.locations {
            if location.name == view.annotation.title {
                let detailViewController: DetailViewController =
                    DetailViewController(location: location, dealDay: nil)
                
                self.presentViewController(detailViewController, animated: true, completion: nil)
            }
        }
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        if isFirstLoad {
            self.allOverlays = self.mapView.overlays as? [MKOverlay]
            isFirstLoad = false
        }
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
        if isFirstLoad {
            self.allOverlays = self.mapView.overlays as? [MKOverlay]
            isFirstLoad = false
        }
    }
}
