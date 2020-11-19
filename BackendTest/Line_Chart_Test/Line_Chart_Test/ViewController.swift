//
//  ViewController.swift
//  Line_Chart_Test
//
//  Created by Oliver Reckord Groten on 11/19/20.
//  Copyright © 2020 oreckord. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints
import SimpleCheckbox

class ViewController: UIViewController, ChartViewDelegate {
    
    
    
    lazy var lineChartView1: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        return chartView
    }()
    
    lazy var lineChartView2: LineChartView = {
           let chartView = LineChartView()
           chartView.backgroundColor = .systemOrange
           return chartView
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.subviews[0].addSubview(lineChartView1)
        view.subviews[1].addSubview(lineChartView2)
        lineChartView1.centerInSuperview()
        lineChartView1.width(to: view)
        lineChartView1.heightToSuperview()
        lineChartView2.centerInSuperview()
        lineChartView2.width(to: view)
        lineChartView2.heightToSuperview()
        
        setData()
        
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Water Quality")
        
        let data = LineChartData(dataSet: set1)
        lineChartView1.data = data
        lineChartView2.data = data
    }
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 1, y: 10),
        ChartDataEntry(x: 2, y: 13)
    ]
}

