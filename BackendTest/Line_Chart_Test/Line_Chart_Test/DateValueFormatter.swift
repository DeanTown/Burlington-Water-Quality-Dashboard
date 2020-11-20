//
//  DateValueFormatter.swift
//  Line_Chart_Test
//
//  Created by Oliver Reckord Groten on 11/19/20.
//  Copyright © 2020 oreckord. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MM YY"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
