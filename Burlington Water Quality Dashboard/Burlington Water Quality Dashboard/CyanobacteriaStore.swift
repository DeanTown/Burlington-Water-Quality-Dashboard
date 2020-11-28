//
//  CyanobacteriaStore.swift
//  Burlington Water Quality Dashboard
//
//  Created by Owen Anderson on 10/24/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//
import UIKit

class CyanobacteriaDataStore {
    
    var CyanobacteriaDataItems = [Int:[CyanobacteriaDataItem]]()

    // @discardableResult means the caller can ignore the return object
    @discardableResult func createCyanobacteriaDataItem(date: String, latitude: Double, longitude: Double,  bloomIntensity: String, cyanoTaxaPresent: String, cyanobacteriaDensity: Int, region: String, site: Int, station: String, status: String, temperature: Int, waterSurface: String, waterbody: String) -> CyanobacteriaDataItem {
    
        let newCyanobacteriaDataItem = CyanobacteriaDataItem(date: date, latitude: latitude, longitude: longitude,  bloomIntensity: bloomIntensity, cyanoTaxaPresent: cyanoTaxaPresent, cyanobacteriaDensity: cyanobacteriaDensity, region: region, site: site, station: station, status: status, temperature: temperature, waterSurface: waterSurface, waterbody: waterbody)
        
        var tempArray = CyanobacteriaDataItems[site] ?? []
        tempArray.append(newCyanobacteriaDataItem)
        CyanobacteriaDataItems[site] = tempArray
        
        return newCyanobacteriaDataItem
    }
    
    //Loading up initial lists
    init() {
        self.CyanobacteriaDataItems = [Int:[CyanobacteriaDataItem]]()
    }
    
    func printStore() {
        if self.CyanobacteriaDataItems.isEmpty {
            print("Empty")
        } else{
            print("Printing Cyanobacteria Store:")
            for key in self.CyanobacteriaDataItems.keys{
                print("\(key):")
                for item in self.CyanobacteriaDataItems[key] ?? []{
                    print(item.toString())
                }
            }
        }
    }
    
}

