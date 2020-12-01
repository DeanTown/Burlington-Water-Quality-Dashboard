//
//  GraphingVC.swift
//  Burling Water Quality Dashboard
//
//  Created by Oliver Reckord Groten on 11/19/20.
//  Copyright © 2020 oreckord. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints
import SimpleCheckbox

class GraphingVC: UIViewController, ChartViewDelegate {
    
    var dataSource: String = ""
    var location: Any? = nil
    var year: Int? = nil
    
    var yValues: [ChartDataEntry] = []// = [
    //        ChartDataEntry(x: 1500, y: 10),
    //        ChartDataEntry(x: 1600, y: 13),
    //        ChartDataEntry(x: 1700, y: 14),
    //        ChartDataEntry(x: 1800, y: 16),
    //        ChartDataEntry(x: 1900, y: 18),
    //        ChartDataEntry(x: 2000, y: 17),
    //        ChartDataEntry(x: 2100, y: 21)
    //    ]
    
    var cyanobacteriaDataStore = CyanobacteriaDataStore()
    let cyanobacteriaAPI = CyanobacteriaDataAPI()
    
    // Notes:
    // Sewage data on the 16 unique locations in the sewage db is stored in the
    // sewageDataStore ViewController class-level variable.
    // It represents a SewageDataStore object.
    // The SewageDataStore object has an attribute variable,
    // "SewageDataItems" , which is an array that holds SewageDataItems objects. It is within these SewageDataItems objects which we hold our sewage data.
    var sewageDataStore = SewageDataStore()
    let sewageAPI = SewageDataAPI()

    let dispatchGroup = DispatchGroup() // Used for Firebase asyncronous threads
    
    lazy var lineChartView1: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        return chartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        // Determining the data source (Sewage vs. Cyanobacteria)
        // If the selected location is a String --> Sewage
        // Else, --> Cyanobacteria
        self.dataSource = "Sewage"
        if cyanobacteriaAPI.sanatizeInt(input: self.location) != 0 {
            // returned back as an Int
            self.dataSource = "Cyanobacteria"
        }
        // What to do based on the data source
        if self.dataSource == "Cyanobacteria" {
            self.cyanobacteriaHandler(location: cyanobacteriaAPI.sanatizeInt(input: self.location), year: self.year ?? 2018 )
        } // end if cyanobacteria
        else if self.dataSource == "Sewage" {
            sewageHandler()
        }
    } // end viewDidLoad


    func cyanobacteriaHandler(location: Int, year: Int){
        
        self.yValues = [] // clearing out whatever we had in y values from before, if they existed

        view.subviews[1].addSubview(lineChartView1)
        lineChartView1.centerInSuperview()
        lineChartView1.width(to: view)
        lineChartView1.heightToSuperview()
        
        self.dispatchGroup.enter() // Starting thread
        // Getting all the unique locations from our cyanobacteria data
        self.cyanobacteriaAPI.getDataFromLocationByYear(cyanobacteriaDataStore: cyanobacteriaDataStore, location: location, year: year){ result in
            self.cyanobacteriaDataStore = result
            self.dispatchGroup.leave() // Leaving thread
        }
        self.dispatchGroup.notify(queue:.main) {
//            self.cyanobacteriaDataStore.printStore()
            if (self.cyanobacteriaDataStore.CyanobacteriaDataItems.isEmpty) {
                print("Empty Cyanobacteria Store!")
            } else {
                var i = 0
                for item in self.cyanobacteriaDataStore.CyanobacteriaDataItems {
                    print(item.cyanobacteriaDensity)
                    self.yValues.append(ChartDataEntry(x: Double(i), y: Double(item.cyanobacteriaDensity)))
                    i += 1
                }
                self.setData()
            } // end else
            
        } // end self.dispathGroup.notify(queue:.main)
       
    } // end cyanobacteriaHandler
    
    func sewageHandler() {
        
        // Building the sewageDataStore with a SewageDataItem element for each location
        self.sewageDataStore.clearStore() // Clearing whatever was previously in the sewage data store
        self.dispatchGroup.enter() // Starting thread
        self.sewageAPI.getAllDataBy_receivingWater_and_year(sewageDataStore:self.sewageDataStore, receivingWater: self.location! as! String, date: self.year!) { result in
            self.sewageDataStore =  result
            self.dispatchGroup.leave() // Leaving thread
        }
        
        // When all threads are finished, the sewageDataStore array should be fully populated
        self.dispatchGroup.notify(queue:.main) {
            self.sewageDataStore.SewageDataItems = self.sewageDataStore.sortStore()
            self.yValues = [] // clearing out whatever we had in y values from before, if they existed
            self.view.subviews[1].addSubview(self.lineChartView1)
            self.lineChartView1.centerInSuperview()
            self.lineChartView1.width(to: self.view)
            self.lineChartView1.heightToSuperview()
            var i = 0
            for item in self.sewageDataStore.SewageDataItems {
                self.yValues.append(ChartDataEntry(x: Double(i), y: Double(item.maxGal)))
                i += 1
            }
            self.sewageDataStore.toString()
            self.setData()
        }
    } // end sewageHandler function

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Water Quality")
        
        let data = LineChartData(dataSet: set1)
        lineChartView1.data = data
    }
    

}

