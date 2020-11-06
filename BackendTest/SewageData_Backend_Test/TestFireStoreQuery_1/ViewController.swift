//
//  ViewController.swift
//  TestFireStoreQuery_1
//
//  Created by Nick Hella on 11/3/20.
//

import UIKit
import Firebase
import Firestore

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        // Load Up The Sewage Data Store
        let sewageDataStore = SewageDataStore()
        
        // Load the Firestore db
        let db = Firestore.firestore()
        
        // Query for the sewage data
        db.collection("sewage").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // Iterate through the documents
                for document in querySnapshot!.documents {
                    
                    // Get the whole document as dictionary
                    let testVar = document.data()
                    print(testVar)
                    print( "String(testVar.dynamicType) -> \(type(of: testVar)) ::\n")
                    
                    // Getting the specific attribute values into their own variables
                    let date = testVar["date"]! as! String
                    let type = testVar["type"]! as! String
                    let minGal = testVar["minGal"]! as! Int
                    let maxGal = testVar["maxGal"]! as! Int
                    let location = testVar["location"] as! String
                    let receivingWater = testVar["receivingWater"]! as! String

                    // Printing the variables
                    print("date --> \(date)")
                    print("type --> \(type)")
                    print("minGal --> \(minGal)")
                    print("maxGal --> \(maxGal)")
                    print("location --> \(location)")
                    print("receivingWater --> \(receivingWater)")
                    print("\n------------------\n")
                    
                    // Creating objects for each of the returned documents by shopping at the sewage data store
//                    if location == "Burlington" {
//                        sewageDataStore.createBurlingtonItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
//                    }
//                    if location == "Rutland" {
//                        sewageDataStore.createRutlandItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
//                    }
//                    if location == "Winooski" {
//                        sewageDataStore.createWinooskiItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
//                    }
                    
                    sewageDataStore.createSewageDataItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
                    
                // Print the items in our Sewage Data Store
                sewageDataStore.toString()
                    
                } // end for
            } // end else
        } // end db query
        // Calling super.viewDidLoad
        super.viewDidLoad()
    } // end viewDidLoad
} // end class
