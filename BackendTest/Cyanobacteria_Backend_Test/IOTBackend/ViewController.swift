//
//  ViewController.swift
//  IOTBackend
//
//  Created by Owen Anderson on 11/4/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initilize firebase connection
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let db = Firestore.firestore();
        
        // run test queries
        let date = "2016-06-14"
        
        // get safety of cyanobacteria by date
        print("Cyanobacteria saftey on " + date)
        db.collection("cyanobacteria").whereField("date", isEqualTo: date)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(String(describing: document.data()["municipality"] ?? "")) => \(String(describing: document.data()["status"] ?? ""))")
                    }
                }
        }
    
    }


}

