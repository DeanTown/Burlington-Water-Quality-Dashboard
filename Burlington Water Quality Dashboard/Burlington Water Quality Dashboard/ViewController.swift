//
//  ViewController.swift
//  Burlington Water Quality Dashboard
//
//  Created by Prasidha Timsina on 10/27/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    
    private var poi: [PointsOfInterest] = []


    override func viewDidLoad() {
        super.viewDidLoad()
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

    }

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
    }


}

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
}

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
}
