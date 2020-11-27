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
    //manually adding one sewage runoff location point till we get a list of lats and longs
    let sewageRunoff = PointsOfInterest(title: "Runoff from ___", descriptionOfPlace: "tap here for more sewage info", coordinate: CLLocationCoordinate2D(latitude: 44.5317895, longitude: -73.2772155))
    
    private var poi: [PointsOfInterest] = []
    
    private var sewageRunoffs: [PointsOfInterest] = []
    
    var sewageDataStore = SewageDataStore()
    let sewageAPI = SewageDataAPI()
    let dispatchGroup = DispatchGroup()
    

    override func viewDidLoad() {
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

            
        // BACK END DATA HANDLING
        back_end_handler()
        // Notes:
        // Sewage data on the 16 unique locations in the sewage db is stored in the
        // sewageDataStore ViewController class-level variable.
        // It represents a SewageDataStore object.
        // The SewageDataStore object has an attribute variable,
        // "SewageDataItems" , which is an array that holds SewageDataItems objects. It is within these SewageDataItems objects which we hold our sewage data.
        //    @TODO: nhella
        //      At some point, in my code down below I need to hook the debug date variable
        //      to retreive its value from some widget on the front end
        
        
        // CALLING THE REAL viewDidLoad FUNCTION
        super.viewDidLoad()

    } // end viewDidLoad function
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //TODO: Oliver when your code is all set, use this to navigate to your screen, and use this to also
        //tell your screen what to do
//      let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "anotherViewController") as! AnotherViewController
//      anotherViewController.dataToLoad = thisButtonsData
//      self.navigationController?.pushViewController(anotherViewController, animated: true)
        print("annotation has been clicked on!")

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

        mapView.addAnnotation(sewageRunoff)
        
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
    
    func back_end_handler(){
        
        // Querying the Sewage data for the unique locations in the data set
        var uniqueLocations: [String] = [] // intializing unique locations array
        self.dispatchGroup.enter() // Starting thread
        // Getting all the unique locations from our sewage data
        self.sewageAPI.returnUniqueLocation(uniqueLocations:uniqueLocations) { result in
            uniqueLocations = result
            self.dispatchGroup.leave() // Leaving thread when result comes back
        }
        
        // When thread is finished, the uniqueLocations array should be populated
        self.dispatchGroup.notify(queue:.main) {
            
            print("\n\nBEFORE:: Unique locations: \(uniqueLocations)") // DEBUG -- REMOVE
            print("\(uniqueLocations.count)\n\n") // DEBUG -- REMOVE
            
            // Building the sewageDataStore with a SewageDataItem element for each location
            let date: Int = 2019 // DEBUG VALUE -- REMOVE
            for location in uniqueLocations {
                self.dispatchGroup.enter() // Starting thread
                self.sewageAPI.getLatestDataFromLocations_and_loadSewageStore(sewageDataStore:self.sewageDataStore, location: location, date: date) { result in
                    self.sewageDataStore = result
                    self.dispatchGroup.leave() // Leaving thread
                }
            }
            
            // When all threads are finished, the sewageDataStore array should be fully populated
            self.dispatchGroup.notify(queue:.main) {
                self.sewageDataStore.toString() // DEBUG -- REMOVE
                print(self.sewageDataStore.SewageDataItems.count) // DEBUG -- REMOVE
                
                // Do more stuff below...
                
            } // end when sewageDataStore is populated with most recent data for each location
            
        } // end when unique locations from sewage data came back
        
        print("\n\nAFTER:: \(uniqueLocations)\n\n") // DEBUG -- REMOVE
        print("\(uniqueLocations.count)\n\n") // DEBUG -- REMOVE
        
    } // end back_end_handler function
    
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
            mapView.addAnnotation(sewageRunoff)
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
