//
//  ViewController.swift
//  Burlington Water Quality Dashboard
//
//  Created by Prasidha Timsina on 10/27/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import Firestore

class ViewController: UIViewController {
        
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet weak var mapFilter: UIView!
    @IBOutlet weak var annotationFilter: UIButton!
    @IBOutlet weak var areasFilter: UIButton!
    @IBOutlet var yearPicker: UISegmentedControl!
    
    var yearSelection: Int = 2018
    var siteSelection: Any? = nil
    
    @IBAction func yearChangeAction(_ sender: UISegmentedControl) {
        switch yearPicker.selectedSegmentIndex {
        //case 0 is 2020, 1 is 2019....so do with that what you want, create a date var most likely...
        case 0:
            print("Year selected is: 2020")
            self.yearSelection = 2018
        case 1:
            self.yearSelection = 2016
            print("Year selected is: 2016")
        case 2:
            print("Year selected is: 2015")
            self.yearSelection = 2016
        default:
            break
        }
    }
    
    
    private var poi: [PointsOfInterest] = []
//    let sewageRunoff = PointsOfInterest(title: "Runoff Into Winooski", descriptionOfPlace: "tap here for more sewage info", coordinate: CLLocationCoordinate2D(latitude: 44.530598, longitude: -73.274215))

    
//    Sewage locations we can hard code:
//    ##         Location:                    Lat:         Long:
//    ##         Winooski                --> 44.530598    -73.274215
//    ##         Pine St Barge Canal     --> 44.469254    -73.219233
//    ##         Shelburne Bay           --> 44.422171    -73.231547
//
//    // Winooski
//    let sewageRunoffWinooski = PointsOfInterest(title: "Runoff Into Winooski", descriptionOfPlace: "tap here for more sewage info", coordinate: CLLocationCoordinate2D(latitude: 44.530598, longitude: -73.274215))
//    // Pine St Barge Canal
//    let sewageRunoffPineStBargeCanal = PointsOfInterest(title: "Runoff Into Pine St Barge Canal", descriptionOfPlace: "tap here for more sewage info", coordinate: CLLocationCoordinate2D(latitude: 44.469254, longitude: -73.219233))
//    // Shelburne Bay
//    let sewageRunoffShelburneBay = PointsOfInterest(title: "Runoff Into Shelburne Bay", descriptionOfPlace: "tap here for more sewage info", coordinate: CLLocationCoordinate2D(latitude: 44.422171, longitude: -73.231547))
    
    // Sewage Run Offs Array:: Winooski, Pine St Barge Canal, Shelburne Bay
    private var sewageRunoffs: [PointsOfInterest] = [PointsOfInterest(title: "Runoff Into Winooski", descriptionOfPlace: "Winooski", coordinate: CLLocationCoordinate2D(latitude: 44.530598, longitude: -73.274215)), PointsOfInterest(title: "Runoff Into Pine St Barge Canal", descriptionOfPlace: "Pine St Barge Canal", coordinate: CLLocationCoordinate2D(latitude: 44.469254, longitude: -73.219233)), PointsOfInterest(title: "Runoff Into Shelburne Bay", descriptionOfPlace: "Shelburne Bay", coordinate: CLLocationCoordinate2D(latitude: 44.422171, longitude: -73.231547)) ]
    
    
    // Variable to handle all calls to the sewage data DB
    let sewageAPI = SewageDataAPI()
    
    var cyanobacteriaDataStore = CyanobacteriaDataStore()
    let cyanobacteriaAPI = CyanobacteriaDataAPI()
    
    // Used for asyncronous firebase API threads
    let dispatchGroup = DispatchGroup()
    

    override func viewDidLoad() {
        
        print("\n\nviewDidLoad called\n\n")
        
        view.bringSubviewToFront(mapFilter)
        self.mapView.delegate = self
        
        // Adding a bit of styling to the map filter
        self.mapFilter.layer.cornerRadius = 25
        self.mapFilter.layer.masksToBounds = true
        
        mapView.register(
          LocationViews.self,
          forAnnotationViewWithReuseIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // FRONT END HANDLING
        map_handler()
        // Notes:

        
        cyano_back_end_handler(location: 54, year: 2017)
        
        // CALLING THE REAL viewDidLoad FUNCTION
        super.viewDidLoad()

    } // end viewDidLoad function
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //TODO: Oliver when your code is all set, use this to navigate to your screen, and use this to also
        //tell your screen what to do
//      let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "Graphing") as! GraphingVC
//      anotherViewController.dataToLoad = thisButtonsData
//      self.navsigationController?.pushViewController(anotherViewController, animated: true)
        
        print("annotation has been clicked on!")
        
        if let subtitle = view.annotation?.subtitle, let id = subtitle {
            let siteIdentifier = String(id) // default value is string
            if cyanobacteriaAPI.sanatizeInt(input: siteIdentifier) != 0 {
                // returned back as an Int
                let siteIdentifier = cyanobacteriaAPI.sanatizeInt(input: siteIdentifier)
            }
            print("Site identifier is: \(siteIdentifier)")
            self.siteSelection = siteIdentifier
        }
                
        performSegue(withIdentifier: "detailView", sender: self) // this is going to call the function "prepare" below

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dest = segue.destination as! GraphingVC // setting the segue destination as the Graphing view controller
        
        // passing data to the graphing view controller
        dest.location = self.siteSelection
        dest.year = self.yearSelection

    }
    
    
    func map_handler(){
        
        // Do any additional setup after loading the view.
        let initialLocation = CLLocation(latitude: 44.4831208, longitude: -73.2968602)
        //lat and long for Burlington VT is @44.4926914,-73.2968602
        mapView.centerToLocation(initialLocation)
        
        //limit the map to only the area we want
        let burlingtonWaterArea = CLLocation(latitude: 44.4831208, longitude: -73.2968602)
        let region = MKCoordinateRegion(center: burlingtonWaterArea.coordinate, latitudinalMeters: 50000, longitudinalMeters: 60000)
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(cameraZoomRange, animated: true)
        //TODO: lets really focus this in later when we know the exact coordinates
        //set viewController as delegate of map view
        mapView.delegate = self
//        //create an icon for north beach
//        let northBeach = PointsOfInterest(title: "North Beach", descriptionOfPlace: "A public beach in burlington VT", coordinate: CLLocationCoordinate2D(latitude: 44.492238, longitude: -73.2431204))
//        mapView.addAnnotation(northBeach)
        
        
        //creating an annotation for sewage run off, we can add more once we get the lats and longs for it:

        //mapView.addAnnotation(sewageRunoff)
        for el in sewageRunoffs {
            mapView.addAnnotation(el)
        }
        
        // displaying the array of points of interest to the map
        mapView.register(
          LocationViews.self,
          forAnnotationViewWithReuseIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier)
        loadPOIData()
        annotationFilter.isSelected = true
        areasFilter.isSelected = true
        mapView.addAnnotations(poi)
        let burlingtonVerlay = (MKPolygon(coordinates:Constants.burlingtonArea,count:Constants.burlingtonArea.count))
        mapView.addOverlay(burlingtonVerlay)
    } // end map_handler

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polygonView = MKPolygonRenderer(overlay: overlay)
        polygonView.strokeColor = UIColor.orange.withAlphaComponent(0.7)
        polygonView.fillColor = UIColor.orange.withAlphaComponent(0.2)
        return polygonView
        
    } // end mapView function

    private func loadPOIData() {
        guard
            let fileName = Bundle.main.url(forResource: "AreasWeHaveDataOn", withExtension: "geojson"),
            let areaData = try? Data(contentsOf: fileName)
        else {
            return
        }
        do {
            let features = try MKGeoJSONDecoder().decode(areaData).compactMap {
                $0 as? MKGeoJSONFeature
            }
            let validWorks = features.compactMap(PointsOfInterest.init)
            poi.append(contentsOf: validWorks)
        } catch {
            print("This error came up: \(error)!")
        }
        
    } // end loadPOIData function
    
    func cyano_back_end_handler(location: Int, year: Int){
        self.dispatchGroup.enter() // Starting thread
        // Getting all the unique locations from our cyanobacteria data
        self.cyanobacteriaAPI.getDataFromLocationByYear(cyanobacteriaDataStore: cyanobacteriaDataStore, location: location, year: year){ result in
            self.cyanobacteriaDataStore = result
            self.dispatchGroup.leave() // Leaving thread
        }
        self.dispatchGroup.notify(queue:.main) {
            self.cyanobacteriaDataStore.printStore()
        }
    }
    
    // Whatever 'filters' we want to add, we can create individual checkboxes for them
    // and for each filter, create an overlay and add and remove it
    //this one is for overlays
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        let burlingtonVerlay = (MKPolygon(coordinates:Constants.burlingtonArea,count:Constants.burlingtonArea.count))
        if sender.isSelected {
            sender.isSelected = false
            mapView.removeOverlays(mapView.overlays)
        } else {
            sender.isSelected = true
            mapView.addOverlay(burlingtonVerlay)
        }
    }
    // this one is for annotations (pins for Points of interest)
    // for this one, in view did load we set it to selected right away
    @IBAction func checkBoxTapped2(_ sender: UIButton) {
        if (sender.isSelected) {
            sender.isSelected = false
            mapView.removeAnnotations(mapView.annotations)
        } else {
            sender.isSelected = true
            mapView.addAnnotations(sewageRunoffs)
            mapView.addAnnotations(poi)
        }
    }

} // end ViewController class

// making sure that we get the correct level of zoom
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 20000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
} // end extension


//adding an annotation view with more info
extension ViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? PointsOfInterest else {
//            return nil
//        }
//        let identifier = "icon of location"
//        var view: MKAnnotationView
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as?
//            MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
    
} // end extension


// citing icons below
// icon for beaches (not filter ones) is from:https://www.flaticon.com/free-icon/beach_119596
// icon for sewage runoff (not filter ones): https://www.flaticon.com/free-icon/sewage_2154837
// these below are filter icons:
// icon for areas is from: https://img.icons8.com/cotton/2x/worldwide-location--v2.png
// icon for beaches is from: https://img.icons8.com/cotton/2x/ffffff/safety-float-1.png
// I (Prasidha) made the icon for sewage
