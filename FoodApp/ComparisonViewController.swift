//
//  ComparisonViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-03-04.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit
import GraphKit

class ComparisonViewController: UIViewController, GKBarGraphDataSource {
    
    var item1 : [String:Any] = [:]
    var item2 : [String:Any] = [:]
    
    var item1Values : [String:Any] = [:]
    var item2Values : [String:Any] = [:]
    
    var valueNames : [String] = []
    var values : [Float] = []
    
    var graph : GKBarGraph!

    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var item1Label: UILabel!
    @IBOutlet weak var item2Label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        item1Label.text = item1["name"] as? String
        item2Label.text = item2["name"] as? String
        
        item1Values = item1["nutrientValues"] as! [String : Any]
        item2Values = item2["nutrientValues"] as! [String : Any]
        
        addValues()
        
        graph = GKBarGraph(frame: CGRect(x: 0, y: 0, width: graphView.frame.width, height: graphView.frame.height))
        graph.dataSource = self
        
        graphView.addSubview(graph)
        
        graph.draw()
    }
    
    func addValues() {
        valueNames.append("kcal")
        valueNames.append("kcal")
        valueNames.append("fat")
        valueNames.append("fat")
        valueNames.append("carb")
        valueNames.append("carb")
        values.append(item1Values["energyKcal"] as! Float)
        values.append(item2Values["energyKcal"] as! Float)
        values.append(item1Values["fat"] as! Float)
        values.append(item2Values["fat"] as! Float)
        values.append(item1Values["carbohydrates"] as! Float)
        values.append(item2Values["carbohydrates"] as! Float)
    }
    
    public func numberOfBars() -> Int {
        return 6
    }
    
    public func valueForBar(at index: Int) -> NSNumber! {
        return values[index]/10 as NSNumber!
    }
    
    public func colorForBar(at index: Int) -> UIColor! {
        return (index % 2 == 0 ? UIColor.red : UIColor.blue)
    }
    
    public func animationDurationForBar(at index: Int) -> CFTimeInterval {
        return 1.0
    }
    
    public func titleForBar(at index: Int) -> String! {
        return valueNames[index]
    }
}
