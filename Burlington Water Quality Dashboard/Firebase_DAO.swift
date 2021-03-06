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
    
    func get_collection_document_count(sewageDataStore: SewageDataStore, completion:@escaping((Int) -> ())) -> Int {
        // Clearing out what's in the store
        sewageDataStore.clearStore()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()
        
        // Count of items/documents in sewage collection
        var counter = 0
        
        dispatchGroup.enter()
        // Getting everything in the sewage db
        db.collection("sewage3").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                dispatchGroup.leave()
            } else {
                for document in querySnapshot!.documents {
                     counter = counter + 1
                } // end for
                dispatchGroup.leave()
            } // end else
        } // end db collection
        dispatchGroup.notify(queue:.main) {
            completion(counter)
        }
        return counter
    }// end func

    func getLatestDataBy_receivingWater_and_year(sewageDataStore: SewageDataStore, receivingWater: String, date: Int, completion:@escaping((SewageDataStore) -> ())) -> SewageDataStore {
        
        // Clearing out what's in the store
        sewageDataStore.clearStore()
        
        // Query the sewage data collection for a list of the unique locations in our db
        let dispatchGroup = DispatchGroup()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        
        let date_lower = String(date)
        let date_upper = String(date+1)
        
        // For each of the locations, get its' most recent data
        dispatchGroup.enter()
        db.collection("sewage3").whereField("Receiving Water", isEqualTo: receivingWater).whereField("date", isGreaterThanOrEqualTo: date_lower).whereField("date", isLessThan: date_upper).order(by: "date",descending: true).getDocuments() { (querySnapshot, err) in
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
                    let longitude = testVar["Longitude"]! as! String
                    let latitude = testVar["Latitude"]! as! String

                    // Add the sewageDataItem object to the sewage store cart
                    sewageDataStore.createSewageDataItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater, latitude: latitude, longitude: longitude)
                    
                    break // breaking only to grab the most recent data for a particular receiving water value
                } // end for
                dispatchGroup.leave()
            } // end else
        } // end db collection
        dispatchGroup.notify(queue:.main) {
            completion(sewageDataStore)
        }
        return sewageDataStore
    }// end func
    
    func getAllDataBy_receivingWater_and_year(sewageDataStore: SewageDataStore, receivingWater: String, date: Int, completion:@escaping((SewageDataStore) -> ())) -> SewageDataStore {
                
        // Query the sewage data collection for a list of the unique locations in our db
        let dispatchGroup = DispatchGroup()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        
        let date_lower = String(date)
        let date_upper = String(date+1)
        
//        print("\n\nInside Firebase_DAO.SewageDataAPI.getAllDataBy_receivingWater_and_year..")
//        print("\t\t receivingWater is: \(receivingWater)")
//        print("\t\t date_lower is: \(date_lower)")
//        print("\t\t date_upper is: \(date_upper)")
        
        
        // For each of the locations, get its' most recent data
        dispatchGroup.enter()
        db.collection("sewage3").whereField("receivingWater", isEqualTo: receivingWater).whereField("date", isGreaterThanOrEqualTo: date_lower).whereField("date", isLessThan: date_upper).order(by: "date",descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("\t\t\t Error getting documents: \(err)")
                dispatchGroup.leave()
            } else {
                //print("\t\t\t Number of documents: \(querySnapshot!.documents.count)")
                for document in querySnapshot!.documents {
                    
                    // Get the whole document as dictionary
                    let testVar = document.data()
                    //print("\t\t\t \(testVar)")
                                        
                    // Getting the specific attribute values into their own variables
                    let date = testVar["date"]! as! String
                    let type = testVar["type"]! as! String
                    let minGal = Int(testVar["minGal"]! as! String)!
                    let maxGal = Int(testVar["maxGal"]! as! String)!
                    let location = testVar["location"] as! String
                    let receivingWater = testVar["receivingWater"]! as! String
                    let longitude = testVar["longitude"]! as! String
                    let latitude = testVar["latitude"]! as! String

                    // Add the sewageDataItem object to the sewage store cart
                    sewageDataStore.createSewageDataItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater, latitude: latitude, longitude: longitude)
                    
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
        
        // Query the cyanobacteria data collection for a list of the unique locations in our db
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
                    let site = self.sanatizeInt(input: testVar["site"])
                    
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
    
    
    func getDataFromLocationByYear(cyanobacteriaDataStore: CyanobacteriaDataStore, location: Int, year: Int, completion:@escaping((CyanobacteriaDataStore) -> ())) -> CyanobacteriaDataStore {
        
        // Query the cyanobacteria data collection for a list of the unique locations in our db
        let dispatchGroup = DispatchGroup()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        
        let date_lower = "\(year)-01-01"
        let date_upper = "\(year)-12-31"
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
                    
                    let date = self.sanatizeString(input: testVar["date"])
                    let latitude = self.sanatizeDouble(input: testVar["latitude"])
                    let longitude = self.sanatizeDouble(input: testVar["longitude"])
                    let bloomIntensity = self.sanatizeString(input: testVar["bloomIntensity"])
                    let cyanoTaxaPresent = self.sanatizeString(input: testVar["cyanoTaxaPresent"])
                    let cyanobacteriaDensity = self.sanatizeInt(input: testVar["cyanobacteriaDensity"])
                    let region = self.sanatizeString(input: testVar["region"])
                    let site = self.sanatizeInt(input: testVar["site"])
                    let station = self.sanatizeString(input: testVar["station"])
                    let status = self.sanatizeString(input: testVar["status"])
                    let temperature = self.sanatizeInt(input: testVar["temperature"])
                    let waterSurface = self.sanatizeString(input: testVar["waterSurface"])
                    let waterbody = self.sanatizeString(input: testVar["waterbody"])
                    
                    // Add the cyanobacteriaDataItem object to the cyanobacteria store cart
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
        
        // Query the cyanobacteria data collection for a list of the unique locations in our db
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
                    
                    let date = self.sanatizeString(input: testVar["date"])
                    let latitude = self.sanatizeDouble(input: testVar["latitude"])
                    let longitude = self.sanatizeDouble(input: testVar["longitude"])
                    let bloomIntensity = self.sanatizeString(input: testVar["bloomIntensity"])
                    let cyanoTaxaPresent = self.sanatizeString(input: testVar["cyanoTaxaPresent"])
                    let cyanobacteriaDensity = self.sanatizeInt(input: testVar["cyanobacteriaDensity"])
                    let region = self.sanatizeString(input: testVar["region"])
                    let site = self.sanatizeInt(input: testVar["site"])
                    let station = self.sanatizeString(input: testVar["station"])
                    let status = self.sanatizeString(input: testVar["status"])
                    let temperature = self.sanatizeInt(input: testVar["temperature"])
                    let waterSurface = self.sanatizeString(input: testVar["waterSurface"])
                    let waterbody = self.sanatizeString(input: testVar["waterbody"])
                    
                    // Add the cyanobacteriaDataItem object to the cyanobacteria store cart
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

} // end class

