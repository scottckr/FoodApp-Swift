//
//  FavoriteTableViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-02-18.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    var favoriteItems : [[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "favoriteItems") != nil {
            favoriteItems = UserDefaults.standard.object(forKey: "favoriteItems") as! [[String : Any]]
        }
        
        tableView.reloadData()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.editButtonItem.title = "Redigera"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        var item = favoriteItems[indexPath.row]
        cell.data = item
        // Configure the cell...
        cell.textLabel?.text = item["name"] as! String?
        var cellValues : [String:Any] = item["nutrientValues"] as! [String : Any]
        let cellKcal = cellValues["energyKcal"] as! Int
        cell.detailTextLabel?.text = "Kalorier (kcal): \(cellKcal)"
     
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favoriteItems.remove(at: indexPath.row)
            UserDefaults.standard.set(favoriteItems, forKey: "favoriteItems")
            UserDefaults.standard.synchronize()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let infoVC = segue.destination as! InfoViewController
        if let cell = sender as? CustomTableViewCell {
            infoVC.itemInfo = cell.data
        }
    }
}
