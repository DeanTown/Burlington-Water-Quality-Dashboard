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
    
    public var id = 22
    var cyanobacteriaDataStore = CyanobacteriaDataStore()
    let cyanobacteriaAPI = CyanobacteriaDataAPI()
        let dispatchGroup = DispatchGroup()
    
    lazy var lineChartView1: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        return chartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.subviews[1].addSubview(lineChartView1)
        lineChartView1.centerInSuperview()
        lineChartView1.width(to: view)
        lineChartView1.heightToSuperview()
        
        self.dispatchGroup.enter() // Starting thread
        // Getting all the unique locations from our cyanobacteria data
        self.cyanobacteriaAPI.getDataFromLocationByYear(cyanobacteriaDataStore: cyanobacteriaDataStore, location: 22, year: "2018"){ result in
            self.cyanobacteriaDataStore = result
            self.dispatchGroup.leave() // Leaving thread
        }
        self.dispatchGroup.notify(queue:.main) {
//            self.cyanobacteriaDataStore.printStore()
//            print(self.cyanobacteriaDataStore.CyanobacteriaDataItems[0][0].date)
        }
        
        setData()
        
        print(id)
        
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Water Quality")
        
        let data = LineChartData(dataSet: set1)
        lineChartView1.data = data
    }
    
    let yValues: [ChartDataEntry] = []// = [
//        ChartDataEntry(x: 1500, y: 10),
//        ChartDataEntry(x: 1600, y: 13),
//        ChartDataEntry(x: 1700, y: 14),
//        ChartDataEntry(x: 1800, y: 16),
//        ChartDataEntry(x: 1900, y: 18),
//        ChartDataEntry(x: 2000, y: 17),
//        ChartDataEntry(x: 2100, y: 21)
//    ]
}

