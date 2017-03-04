//
//  InfoTableViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-02-20.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {
    @IBOutlet weak var cellOne: UITableViewCell!
    @IBOutlet weak var cellTwo: UITableViewCell!
    @IBOutlet weak var cellThree: UITableViewCell!
    @IBOutlet weak var cellFour: UITableViewCell!
    @IBOutlet weak var cellFive: UITableViewCell!
    @IBOutlet weak var cellSix: UITableViewCell!
    
    var cellPrefixes : [String] = ["Kalorier (kJ)", "Kalorier (kcal)", "Fett", "Kolhydrater", "Protein", "Salt"]
    var cellTexts : [Float] = [0, 0, 0, 0, 0, 0]
    
    var itemInfo : [String:Any] = [:]
    var nutrientValues : [String:Any] = [:]
    var healthValue : Float = 0
    
    var itemNumber : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nutrientValues = itemInfo["nutrientValues"] as! [String : Any]
        
        self.cellTexts[0] = nutrientValues["energyKj"] as! Float
        self.cellTexts[1] = nutrientValues["energyKcal"] as! Float
        self.cellTexts[2] = nutrientValues["fat"] as! Float
        self.cellTexts[3] = nutrientValues["carbohydrates"] as! Float
        self.cellTexts[4] = nutrientValues["protein"] as! Float
        self.cellTexts[5] = nutrientValues["salt"] as! Float
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTexts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        // Configure the cell...
        if indexPath.row >= 0 && indexPath.row <= 1 {
            cell.textLabel?.text = "\(cellPrefixes[indexPath.row]): \(Int(cellTexts[indexPath.row]))"
        } else {
            cell.textLabel?.text = "\(cellPrefixes[indexPath.row]): \(cellTexts[indexPath.row])g"
        }
        
        return cell
    }
}
