//
//  Firebase_DAO.swift
//  Burlington Water Quality Dashboard
//
//  Created by Nick Hella on 11/8/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//

import Firebase
import Firestore
import UIKit


class SewageDataAPI {
            
    func returnUniqueLocation(uniqueLocations: [String], completion:@escaping(([String]) -> ())) -> [String] {
        
        var UniqueLocations = uniqueLocations
        
        // Query the sewage data collection for a list of the unique locations in our db
        let dispatchGroup = DispatchGroup()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        dispatchGroup.enter()
        db.collection("sewage").order(by: "date").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                dispatchGroup.leave()
            } else {
                
                // Iterate through the documents
                for document in querySnapshot!.documents {
                    
                    // Get the whole document as dictionary
                    let testVar = document.data()
                                        
                    // Getting the location attributes into their own variables
                    let location = testVar["location"] as! String
                    let receivingWater = testVar["receivingWater"]! as! String
                    
                    if !UniqueLocations.contains(location) {
                        UniqueLocations.append(location)
                        //print(location)
                    }
                } // end for
                dispatchGroup.leave()
            } // end else
        } // end db query
        dispatchGroup.notify(queue:.main) {
            //print("UNIQUE LOCATIONS ARRAY: \(UniqueLocations)")
            completion(UniqueLocations)
        }
        return UniqueLocations
    } // end func
    
    func getLatestDataFromLocations_and_loadSewageStore(sewageDataStore: SewageDataStore, location: String, date: Int, completion:@escaping((SewageDataStore) -> ())) -> SewageDataStore {
        
        // Query the sewage data collection for a list of the unique locations in our db
        let dispatchGroup = DispatchGroup()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        
        let date_lower = String(date)
        let date_upper = String(date+1)
        
        // For each of the locations, get its' most recent data
        dispatchGroup.enter()
        db.collection("sewage").whereField("location", isEqualTo: location).whereField("date", isGreaterThanOrEqualTo: date_lower).whereField("date", isLessThan: date_upper).order(by: "date",descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                dispatchGroup.leave()
            } else {
                for document in querySnapshot!.documents {
                    // Get the whole document as dictionary
                    let testVar = document.data()
                    
                    // Getting the specific attribute values into their own variables
                    let date = testVar["date"]! as! String
                    let type = testVar["type"]! as! String
                    let minGal = testVar["minGal"]! as! Int
                    let maxGal = testVar["maxGal"]! as! Int
                    let location = testVar["location"] as! String
                    let receivingWater = testVar["receivingWater"]! as! String

                    // Add the sewageDataItem object to the sewage store cart
                    sewageDataStore.createSewageDataItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
                    
                    break
                } // end for
                dispatchGroup.leave()
            } // end else
        } // end db collection
        dispatchGroup.notify(queue:.main) {
            completion(sewageDataStore)
        }
        return sewageDataStore
    }// end func
    
} // end class


class CyanobacteriaDataAPI {
    func returnUniqueLocation(uniqueLocations: [Int], completion:@escaping(([Int]) -> ())) -> [Int] {
        
        var UniqueLocations = uniqueLocations
        
        // Query the sewage data collection for a list of the unique locations in our db
        let dispatchGroup = DispatchGroup()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        dispatchGroup.enter()
        db.collection("cyanobacteria").order(by: "date").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                dispatchGroup.leave()
            } else {
                
                // Iterate through the documents
                for document in querySnapshot!.documents {
                    
                    // Get the whole document as dictionary
                    let testVar = document.data()
                                        
                    // Getting the location attributes into their own variables
                    let site = sanatizeInt(input: testVar["site"])
                    
                    if !UniqueLocations.contains(site) {
                        UniqueLocations.append(site)
                        //print(site)
                    }
                } // end for
                dispatchGroup.leave()
            } // end else
        } // end db query
        dispatchGroup.notify(queue:.main) {
            //print("UNIQUE LOCATIONS ARRAY: \(UniqueLocations)")
            completion(UniqueLocations)
        }
        return UniqueLocations
    } // end func
    
    
    func getDataFromLocationByMonth(cyanobacteriaDataStore: CyanobacteriaDataStore, location: Int, date: String, completion:@escaping((CyanobacteriaDataStore) -> ())) -> CyanobacteriaDataStore {
        
        // Query the sewage data collection for a list of the unique locations in our db
        let dispatchGroup = DispatchGroup()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        
        let date_lower = "\(date)-01"
        let date_upper = "\(date)-31"
        // For each of the locations, get its most recent data
        dispatchGroup.enter()
        db.collection("cyanobacteria").whereField("site", isEqualTo: location).whereField("date", isGreaterThanOrEqualTo: date_lower).whereField("date", isLessThanOrEqualTo: date_upper).order(by: "date",descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                dispatchGroup.leave()
            } else {
                for document in querySnapshot!.documents {
                    // Get the whole document as dictionary
                    let testVar = document.data()
                    
                    let date = sanatizeString(input: testVar["date"])
                    let latitude = sanatizeDouble(input: testVar["latitude"])
                    let longitude = sanatizeDouble(input: testVar["longitude"])
                    let bloomIntensity = sanatizeString(input: testVar["bloomIntensity"])
                    let cyanoTaxaPresent = sanatizeString(input: testVar["cyanoTaxaPresent"])
                    let cyanobacteriaDensity = sanatizeInt(input: testVar["cyanobacteriaDensity"])
                    let region = sanatizeString(input: testVar["region"])
                    let site = sanatizeInt(input: testVar["site"])
                    let station = sanatizeString(input: testVar["station"])
                    let status = sanatizeString(input: testVar["status"])
                    let temperature = sanatizeInt(input: testVar["temperature"])
                    let waterSurface = sanatizeString(input: testVar["waterSurface"])
                    let waterbody = sanatizeString(input: testVar["waterbody"])
                    
                    // Add the cyanobacteriaDataItem object to the sewage store cart
                    cyanobacteriaDataStore.createCyanobacteriaDataItem(date: date, latitude: latitude, longitude: longitude,  bloomIntensity: bloomIntensity, cyanoTaxaPresent: cyanoTaxaPresent, cyanobacteriaDensity: cyanobacteriaDensity, region: region, site: site, station: station, status: status, temperature: temperature, waterSurface: waterSurface, waterbody: waterbody)
                } // end for
                dispatchGroup.leave()
            } // end else
        } // end db collection
        dispatchGroup.notify(queue:.main) {
            completion(cyanobacteriaDataStore)
        }
        return cyanobacteriaDataStore
    }// end func
    
    func getDataFromLocation(cyanobacteriaDataStore: CyanobacteriaDataStore, location: Int, completion:@escaping((CyanobacteriaDataStore) -> ())) -> CyanobacteriaDataStore {
        
        // Query the sewage data collection for a list of the unique locations in our db
        let dispatchGroup = DispatchGroup()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        // For each of the locations, get its most recent data
        dispatchGroup.enter()
        db.collection("cyanobacteria").whereField("site", isEqualTo: location).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                dispatchGroup.leave()
            } else {
                for document in querySnapshot!.documents {
                    // Get the whole document as dictionary
                    let testVar = document.data()
                    
                    let date = sanatizeString(input: testVar["date"])
                    let latitude = sanatizeDouble(input: testVar["latitude"])
                    let longitude = sanatizeDouble(input: testVar["longitude"])
                    let bloomIntensity = sanatizeString(input: testVar["bloomIntensity"])
                    let cyanoTaxaPresent = sanatizeString(input: testVar["cyanoTaxaPresent"])
                    let cyanobacteriaDensity = sanatizeInt(input: testVar["cyanobacteriaDensity"])
                    let region = sanatizeString(input: testVar["region"])
                    let site = sanatizeInt(input: testVar["site"])
                    let station = sanatizeString(input: testVar["station"])
                    let status = sanatizeString(input: testVar["status"])
                    let temperature = sanatizeInt(input: testVar["temperature"])
                    let waterSurface = sanatizeString(input: testVar["waterSurface"])
                    let waterbody = sanatizeString(input: testVar["waterbody"])
                    
                    // Add the sewageDataItem object to the sewage store cart
                    cyanobacteriaDataStore.createCyanobacteriaDataItem(date: date, latitude: latitude, longitude: longitude,  bloomIntensity: bloomIntensity, cyanoTaxaPresent: cyanoTaxaPresent, cyanobacteriaDensity: cyanobacteriaDensity, region: region, site: site, station: station, status: status, temperature: temperature, waterSurface: waterSurface, waterbody: waterbody)
                    
                } // end for
                dispatchGroup.leave()
            } // end else
            
        } // end db collection
        dispatchGroup.notify(queue:.main) {
            completion(cyanobacteriaDataStore)
        }
        return cyanobacteriaDataStore
    }// end func
} // end class


// Data sanitization helper functions
func sanatizeString(input: Any?) -> String{
    var out: String
    if (input as? String != nil){
        out = input as? String ?? ""
    } else{
        out = ""
    }
    return out
}

func sanatizeInt(input: Any?) -> Int{
    var out: Int
    if (input as? Int != nil){
        out = input as? Int ?? 0
    } else{
        out = 0
    }
    return out
}

func sanatizeDouble(input: Any?) -> Double{
    var out: Double
    if (input as? Double != nil){
        out = input as? Double ?? 0
    } else{
        out = 0
    }
    return out
}


