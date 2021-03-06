//
//  Cyanobacteria.swift
//  Burlington Water Quality Dashboard
//
//  Created by Owen Anderson on 11/16/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//

import UIKit

class CyanobacteriaDataItem: NSObject {
    var date: String
    var latitude: Double
    var longitude: Double
    var bloomIntensity: String
    var cyanoTaxaPresent: String
    var cyanobacteriaDensity: Int
    var region: String
    var site: Int
    var station: String
    var status: String
    var temperature: Int
    var waterSurface: String
    var waterbody: String
    
    init(date: String, latitude: Double, longitude: Double,  bloomIntensity: String, cyanoTaxaPresent: String, cyanobacteriaDensity: Int, region: String, site: Int, station: String, status: String, temperature: Int, waterSurface: String, waterbody: String){
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.bloomIntensity = bloomIntensity
        self.cyanoTaxaPresent = cyanoTaxaPresent
        self.cyanobacteriaDensity = cyanobacteriaDensity
        self.region = region
        self.site = site
        self.station = station
        self.status = status
        self.temperature = temperature
        self.waterSurface = waterSurface
        self.waterbody = waterbody
    }
    
    func toString() -> String{
        return("    date: \(date) site: \(site)")
    }
}
