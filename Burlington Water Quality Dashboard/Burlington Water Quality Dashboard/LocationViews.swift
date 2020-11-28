//
//  LocationViews.swift
//  Burlington Water Quality Dashboard
//
//  Created by Prasidha Timsina on 10/30/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//

import MapKit

class LocationMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let pointsOfInterest = newValue as? PointsOfInterest else {
        return
      }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
  }
}

class LocationViews: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let pointsOfInterest = newValue as? PointsOfInterest else {
        return
      }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      image = pointsOfInterest.image
    }
  }
}
