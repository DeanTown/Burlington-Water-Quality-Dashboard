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
    
    private var poi: [PointsOfInterest] = []
    
    var sewageDataStore = SewageDataStore()
    let sewageAPI = SewageDataAPI()
    let dispatchGroup = DispatchGroup()
    

    override func viewDidLoad() {
        
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
        
        // displaying the array of points of interest to the map
        mapView.register(
          LocationViews.self,
          forAnnotationViewWithReuseIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier)
        loadPOIData()
        mapView.addAnnotations(poi)
        

//        mapView.addOverlay(MKPolygon(
//          coordinates:  Constants.testArea,
//          count:  Constants.testArea.count))
        
        mapView.addOverlay(MKPolygon(
          coordinates:  Constants.burlingtonArea,
          count:  Constants.burlingtonArea.count))
        
    } // end map_handler

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polygonView = MKPolygonRenderer(overlay: overlay)
        polygonView.strokeColor = UIColor.orange.withAlphaComponent(0.7)
        polygonView.fillColor = UIColor.orange.withAlphaComponent(0.2)
        return polygonView
    }

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
        
    } // end map_hanlder function
    
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
        
        print("\n\nAFTER:: \(uniqueLocations)\n\n")
        print("\(uniqueLocations.count)\n\n") // DEBUG -- REMOVE
        
    } // end back_end_handler function

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
