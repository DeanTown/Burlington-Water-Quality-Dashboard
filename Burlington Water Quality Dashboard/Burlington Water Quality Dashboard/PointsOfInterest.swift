//
//  PointsOfInterest.swift
//  Burlington Water Quality Dashboard
//
//  Created by Prasidha Timsina on 10/30/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//

import Foundation
import MapKit

class PointsOfInterest: NSObject, MKAnnotation {
    let title: String?
    let descriptionOfPlace: String?
    let coordinate: CLLocationCoordinate2D
    
    let waterQuality = "Great"
    let typeOfArea: String?
    
    init(
        title: String?,
        descriptionOfPlace: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.descriptionOfPlace = descriptionOfPlace
        self.coordinate = coordinate
        self.typeOfArea = "Beach"
        super.init()
    }
    
    init?(feature: MKGeoJSONFeature) {
        guard
          let point = feature.geometry.first as? MKPointAnnotation,
          let propertiesData = feature.properties,
          let json = try? JSONSerialization.jsonObject(with: propertiesData),
          let properties = json as? [String: Any]
          else {
            return nil
        }
        title = properties["title"] as? String
        descriptionOfPlace = properties["descriptionOfPlace"] as? String
        coordinate = point.coordinate
        typeOfArea = "Beach"
        super.init()
    }
    
    var subtitle: String? {
        return self.descriptionOfPlace
    }
    
    
    var markerTintColor: UIColor  {
      switch waterQuality {
      case "Poor":
        return .red
      case "Okay":
        return .yellow
      case "Great":
        return .green
      default:
        return .green
      }
    }
    
    var image: UIImage {
        if Int(self.descriptionOfPlace ?? "") != nil {
            return #imageLiteral(resourceName: "beachesSelected")
        }
        else {
            return #imageLiteral(resourceName: "sewageRunoff")
        }
    }
    
    
    
    func sanatizeInt(input: Any?) -> Int {
        var out: Int
        if (input as? Int != nil){
            out = input as? Int ?? 0
        } else{
            out = 0
        }
        return out
    }

    
}
