//
//  LocationViews.swift
//  Burlington Water Quality Dashboard
//
//  Created by Prasidha Timsina on 10/30/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//

import Foundation
import MapKit

class LocationViews: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let poi = newValue as? PointsOfInterest else {
        return
      }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        image = poi.image
    }
  }
}


