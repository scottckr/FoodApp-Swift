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
    var cellTexts : [Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    var itemNumber : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let url = URL(string: "http://www.matapi.se/foodstuff/\(itemNumber)") {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                if let unwrappedData = data {
                    do {
                        let options = JSONSerialization.ReadingOptions()
                        if let parsedData = try JSONSerialization.jsonObject(with: unwrappedData, options: options) as? [String:Any] {
                            let itemInfo = parsedData["nutrientValues"] as! [String:Any]
                            
                            self.cellTexts[0] = itemInfo["energyKj"] as! Float
                            self.cellTexts[1] = itemInfo["energyKcal"] as! Float
                            self.cellTexts[2] = itemInfo["fat"] as! Float
                            self.cellTexts[3] = itemInfo["carbohydrates"] as! Float
                            self.cellTexts[4] = itemInfo["protein"] as! Float
                            self.cellTexts[5] = itemInfo["salt"] as! Float
                            
                            self.tableView.reloadData()
                        } else {
                            print("Failed to parse json.")
                        }
                    } catch let error {
                        print("Error parsing json: \(error)")
                    }
                } else {
                    print("No data.")
                }
            }
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellTexts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)

        // Configure the cell...
        if indexPath.row >= 0 && indexPath.row <= 1 {
            cell.textLabel?.text = "\(cellPrefixes[indexPath.row]): \(cellTexts[indexPath.row])"
        } else {
            cell.textLabel?.text = "\(cellPrefixes[indexPath.row]): \(cellTexts[indexPath.row])g"
        }
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
