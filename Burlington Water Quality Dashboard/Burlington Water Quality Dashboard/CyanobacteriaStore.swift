//
//  CyanobacteriaStore.swift
//  Burlington Water Quality Dashboard
//
//  Created by Owen Anderson on 10/24/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//
import UIKit

class CyanobacteriaDataStore {
    var CyanobacteriaDataItems = [CyanobacteriaDataItem]()

    // @discardableResult means the caller can ignore the return object
    @discardableResult func createCyanobacteriaDataItem(date: String, latitude: Double, longitude: Double,  bloomIntensity: String, cyanoTaxaPresent: String, cyanobacteriaDensity: Int, region: String, site: Int, station: String, status: String, temperature: Int, waterSurface: String, waterbody: String) -> CyanobacteriaDataItem {
    
        let newCyanobacteriaDataItem = CyanobacteriaDataItem(date: date, latitude: latitude, longitude: longitude,  bloomIntensity: bloomIntensity, cyanoTaxaPresent: cyanoTaxaPresent, cyanobacteriaDensity: cyanobacteriaDensity, region: region, site: site, station: station, status: status, temperature: temperature, waterSurface: waterSurface, waterbody: waterbody)
        
        self.CyanobacteriaDataItems.append(newCyanobacteriaDataItem)
        
        return newCyanobacteriaDataItem
    }
    
    //Loading up initial lists
    init() {
        self.CyanobacteriaDataItems = [CyanobacteriaDataItem]()
    }
    
    func clearData() {
        self.CyanobacteriaDataItems = []
    }
    
    func printStore() {
        if self.CyanobacteriaDataItems.isEmpty {
            print("Empty")
        } else{
            for item in self.CyanobacteriaDataItems{
                print(item.toString())
            }
        } // end else
    } // end function

} // end class

