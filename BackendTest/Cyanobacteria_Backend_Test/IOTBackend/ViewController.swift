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
        print("Getting Data")
        let docs = getDataByDay(date: date, db: db)
    }
    
    func getDataByDay(date: String, db: Firestore) -> [Cyanobacteria]{
        var dailyReports = [Cyanobacteria]()
        // get safety of cyanobacteria by date
        print("Cyanobacteria saftey on " + date)
        db.collection("cyanobacteria").whereField("date", isEqualTo: date)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let date = sanatizeString(input: document.data()["date"])
                        let latitude = sanatizeDouble(input: document.data()["latitude"])
                        let longitude = sanatizeDouble(input: document.data()["longitude"])
                        let bloomIntensity = sanatizeString(input: document.data()["bloomIntensity"])
                        let cyanoTaxaPresent = sanatizeString(input: document.data()["cyanoTaxaPresent"])
                        let cyanobacteriaDensity = sanatizeInt(input: document.data()["cyanobacteriaDensity"])
                        let region = sanatizeString(input: document.data()["region"])
                        let site = sanatizeInt(input: document.data()["site"])
                        let station = sanatizeString(input: document.data()["station"])
                        let status = sanatizeString(input: document.data()["status"])
                        let temperature = sanatizeInt(input: document.data()["temperature"])
                        let waterSurface = sanatizeString(input: document.data()["waterSurface"])
                        let waterbody = sanatizeString(input: document.data()["waterbody"])
                        
                        dailyReports.append(Cyanobacteria(date: date, latitude: latitude, longitude: longitude, bloomIntensity: bloomIntensity, cyanoTaxaPresent: cyanoTaxaPresent, cyanobacteriaDensity: cyanobacteriaDensity, region: region, site: site, station: station, status: status, temperature: temperature, waterSurface: waterSurface, waterbody: waterbody))
                    }
                }
            }
        return(dailyReports)
    }
    
    // Note month needs to be in format "yyyy-mm"
    func getDataByMonth(month: String, db: Firestore) -> [[Cyanobacteria]]{
        var monthReports = [[Cyanobacteria]()]
        var docs: [Cyanobacteria]
        for i in (1...31){
            var day: String
            if i<10{
                day = "0" + String(i)
            } else{
                day = String(i)
            }
            docs = getDataByDay(date: month + "-" + day , db: db)
            monthReports.append(docs)
        }
        return monthReports
    }
}

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
