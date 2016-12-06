//
//  GraphViewController.swift
//  FacebookOauth2Swift
//
//  Created by Rohan Sonawane on 06/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter{
    
    var xValues: [String]! = []
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xValues[Int(value)]
    }
}

class GraphViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    
    var weatherArray:Array<WeatherForecast>?
    var dateArray: Array<String>? = []
    var temperatureArray: Array<Double>? = []
    var city:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.title = city
        
        for item in weatherArray! {
            let weatherForecast:WeatherForecast = item as WeatherForecast
            let str:String = item.date!
            dateArray?.append(str)
            temperatureArray?.append(weatherForecast.minimumTemperature!)
        }
        
        setChart(dataPoints: dateArray!, values: temperatureArray!)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelPosition = .bothSided
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView?.xAxis.wordWrapEnabled = true
        barChartView?.xAxis.setLabelCount(12, force: false)
        
        var dataEntries: [BarChartDataEntry] = []
        let formato:BarChartFormatter = BarChartFormatter()
        formato.xValues = dataPoints
        let xaxis:XAxis = XAxis()
        
        for i in 0..<dataPoints.count
        {
            let dataEntry = BarChartDataEntry(x: (Double(i)), yValues: [values[i]], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        xaxis.valueFormatter = formato
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Temperature in Degree Celcius")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        barChartView.data = chartData
    }
}
