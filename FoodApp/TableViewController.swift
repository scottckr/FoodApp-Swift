//
//  TableViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-02-16.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var tableItemsJson : [[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let url = URL(string: "http://www.matapi.se/foodstuff") {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                if let unwrappedData = data {
                    do {
                        let options = JSONSerialization.ReadingOptions()
                        if let parsedData = try JSONSerialization.jsonObject(with: unwrappedData, options: options) as? [[String:Any]] {
                            self.tableItemsJson = parsedData
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
        
        return tableItemsJson.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = tableItemsJson[indexPath.row]["name"] as! String?
        
        
        let itemNumber : Int = tableItemsJson[indexPath.row]["number"] as! Int
        
        if let url = URL(string: "http://www.matapi.se/foodstuff/\(itemNumber)") {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                if let unwrappedData = data {
                    do {
                        let options = JSONSerialization.ReadingOptions()
                        if let parsedData = try JSONSerialization.jsonObject(with: unwrappedData, options: options) as? [String:Any] {
                            let itemInfo = parsedData["nutrientValues"]! as! [String : Any]
                            cell.detailTextLabel?.text = "Kalorier (kcal): \(itemInfo["energyKcal"] as! Int)"
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let infoVC = segue.destination as! InfoViewController
        for item in tableItemsJson {
            if item["name"] as? String == cell.textLabel?.text {
                infoVC.itemNumber = item["number"] as! Int
            }
        }
        infoVC.itemName = (cell.textLabel?.text)!
    }
}
