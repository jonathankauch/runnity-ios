//
//  ChartsViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 29/12/2017.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

//import UIKit
//
//protocol GetChartData {
//    func getChartData(with dataPoints: [String], values: [String])
//    var totalDuration: [String] {get set}
//    var totalDistance: [String] {get set}
//}
//
//class ChartViewController: UIViewController, GetChartData {
//    // Chart data
//    var totalDuration = [String]()
//    var totalDistance = [String]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Populate chart data
//        populateChartData()
//        
//        // Bar chart
//        barChart()
//        
//        // Line chart
//        lineChart()
//        
//        // Cubic line chart
//        // cubicChart()
//    }
//
//    func populateChartData() {
//        totalDistance = ["3500", "4500", "5500", "4000", "6000",
//                        "7000", "4000", "9000", "6000", "3000"]
//        totalDuration = ["40", "50", "30", "20", "50",
//                         "60", "45", "70", "60", "35"]
//    }
//    
//    // Chart options
//    func barChart() {
//        let barChart = BarChart(frame: CGRect(x: 0.0, y: 0.0,
//                                              width: self.view.frame.width,
//                                              height: self.view.frame.height))
//        barChart.delegate = self
//        self.view.addSubview(barChart)
//    }
//    
//    func lineChart() {
////        let lineChart = LineChart(frame: CGRect(x: 0.0, y: 0.0,
////                                              width: self.view.frame.width,
////                                              height: self.view.frame.height))
////        lineChart.delegate = self
////        self.view.addSubview(lineChart)
//    }
//    
//    func cubicChart() {
////        let cubicChart = CubicChart(frame: CGRect(x: 0.0, y: 0.0,
////                                               width: self.view.frame.width,
////                                               height: self.view.frame.height))
////        cubicChart.delegate = self
////        self.view.addSubview(cubicChart)
//    }
//    
//    // Conform to protocol
//    func getChartData(with dataPoints: [String], values: [String]) {
//        self.totalDuration = dataPoints
//        self.totalDistance = values
//    }
//}
//
//// MARK: - ChartFormatter required for config x axis
//
//public class ChartFormatter: NSObject, IAxisValueFormatter {
//    var totalDuration = [String]()
//    
//    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return totalDuration[Int(value)]
//    }
//    
//    public func setValues(values: [String]) {
//        self.totalDuration = values
//    }
//}


