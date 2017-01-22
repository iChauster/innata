//
//  ViewThree.swift
//  Innata
//
//  Created by Ivan Chau on 1/22/17.
//  Copyright © 2017 Innata. All rights reserved.
//

import UIKit
import MapKit
import Charts
class ViewThree: UIViewController, ChartViewDelegate {
    @IBOutlet weak var map : MKMapView!
    @IBOutlet weak var graph : LineChartView!
    @IBOutlet weak var backButton : UIBarButtonItem!
    var locations : NSMutableArray = []
    var weights : NSMutableArray = []
    var geoArray : NSMutableArray = []
    var purchasesArray : NSArray = []
    var image : UIImageView = UIImageView()
    var results : [Cash] = []
    @IBOutlet weak var slider : UISlider!
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dict = geoArray[0] as! NSDictionary
        print(dict)
        self.graph.delegate = self;
        self.graph.descriptionText = "Check out your money-time curve.";
        self.graph.descriptionTextColor = UIColor.white;
        self.graph.drawGridBackgroundEnabled = true;
        self.graph.gridBackgroundColor = UIColor(red: 0.0, green: 0.5019, blue: 0.2509, alpha: 1.0)
        self.graph.animate(yAxisDuration: 3.0, easingOption: .easeInOutQuart)
        self.graph.noDataText = "No Data Available";
        
        var sorted = NSMutableArray() as NSArray as! [Any]
        sorted = purchasesArray.sortedArray(comparator: { (a, b) -> ComparisonResult in
            let c = a as! NSDictionary
            let d = b as! NSDictionary
            let cStringDate = c["purchase_date"] as! String
            let dStringDate = d["purchase_date"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            let date = dateFormatter.date(from: cStringDate)
            let dateb = dateFormatter.date(from : dStringDate)
            return date!.compare(dateb!)
        })
        sorted = sorted.reversed()
        //backwards in time
        var index = 0
        let start = sorted[0] as! NSDictionary
        let d = NSMutableDictionary()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let date = dateFormatter.date(from: start.object(forKey: "purchase_date") as! String)
        for i in 0 ..< 4{
            
            let endDate = NSDate(timeInterval: (-604800.0 * (Double(i) + 1.0)), since: (date)!)
            var elapsed = false
            while (!elapsed){
                let obj = sorted[index] as! NSDictionary
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-mm-dd"
                let date2 = dateFormatter.date(from: obj.object(forKey: "purchase_date") as! String)
                if(date2?.compare(endDate as Date) == .orderedAscending){
                    elapsed = true
                }else{
                    if(d.object(forKey: "Week" + String(i)) == nil){
                        d["Week" + String(i)] = obj["amount"] as! Double
                    }else{
                        var g = (d["Week" + String(i)] as! Double) + (obj["amount"] as! Double)
                        d["Week" + String(i)] = g
                    }
                    index += 1
                }
            }
        }
        print(d)
        for (k,v) in d {
            var b = k as! String
            let index = b.index(b.startIndex, offsetBy: 4)

            b = b.substring(from: index)
            let graphob = Cash(week: Int(b), money: (v as! Double))
            self.results.append(graphob)
        }
        print(results)

        self.getData(dataPoints: self.results)
        
        let latDef:CLLocationDegrees  = dict["lat"] as! Double
        let longDef:CLLocationDegrees  = dict["lng"] as! Double
        for i in geoArray {
            let obj = i as! NSDictionary
            let lat : CLLocationDegrees = obj["lat"] as! Double
            let long : CLLocationDegrees = obj["lng"] as! Double
            let location = CLLocation(latitude: lat, longitude: long)
            self.locations.add(location)
            self.weights.add(50)
            
        }
        
        let m = MKCoordinateSpanMake(40, 40)
        let center = CLLocationCoordinate2DMake(latDef, longDef)
        self.map.region = MKCoordinateRegionMake(center, m)
        
        self.image = UIImageView(frame: map.frame)
        self.image.contentMode = .center
        self.view.addSubview(self.image)
        
        self.sliderChaged(sender: self.slider)
        // Do any additional setup after loading the view.
    }
    func getData(dataPoints : [Cash]){
        var data : [ChartDataEntry] = []

        for i in 0..<dataPoints.count{
            let element = dataPoints[i];
            let entry = ChartDataEntry(x:Double(element.week),y:Double(element.money))
            data.append(entry)
        }
        let lineChartDataSet = LineChartDataSet(values: data, label: "Money Spent");
        lineChartDataSet.setColor(UIColor.white.withAlphaComponent(0.5));
        lineChartDataSet.setCircleColor(UIColor.green);
        lineChartDataSet.lineWidth = 2.0;
        lineChartDataSet.circleRadius = 5.0;
        lineChartDataSet.fillAlpha = 65 / 255.0
        lineChartDataSet.fillColor = UIColor.green
        lineChartDataSet.highlightColor = UIColor.white;
        lineChartDataSet.drawCircleHoleEnabled = true;
        lineChartDataSet.mode = .cubicBezier
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setValueTextColor(UIColor.white)
        self.graph.data = lineChartData;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChaged(sender:UISlider){
        let boost = self.slider.value;
        let l  = locations as NSArray as! [Any]
        let w = weights as NSArray as! [Any]
        let heatMap = LFHeatMap.heatMap(for: self.map, boost: boost, locations: l, weights: w)
        self.image.image = heatMap;

    }
    @IBAction func close(sender:Any){
        dismiss(animated: true) { 
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
