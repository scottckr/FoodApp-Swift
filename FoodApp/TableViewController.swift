//
//  TableViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-02-16.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating {
    
    var searchController : UISearchController!
    
    var searchResults : [[String:Any]] = []
    
    var tableItemsJson : [[String:Any]] = []
    
    var shouldUseSearchResult : Bool {
        return searchController.isActive && !(searchController.searchBar.text ?? "").isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        
        getAllTableItems()
    }
    
    func getAllTableItems() {
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
                            print("ALLITEMS: Failed to parse json.")
                        }
                    } catch let error {
                        print("ALLITEMS: Error parsing all json: \(error)")
                    }
                } else {
                    print("ALLITEMS: No data.")
                }
            }
            task.resume()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {

        if let text = searchController.searchBar.text?.lowercased() {
            for item in tableItemsJson {
                let itemName = item["name"] as! String
                if itemName.contains(text) {
                    searchResults.append(item)
                }
            }
            //searchResultNames = tableItemsJson.flatMap({$0["name"] as? String}).filter({ $0.lowercased().contains(text) })
        } else {
            searchResults = []
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldUseSearchResult {
            return searchResults.count
        } else {
            return tableItemsJson.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        var itemNumber : Int = 0
        // Configure the cell...
        if shouldUseSearchResult {
            itemNumber = searchResults[indexPath.row]["number"] as! Int
            //cell.textLabel?.text = searchResultNames[indexPath.row]
        } else {
            itemNumber = tableItemsJson[indexPath.row]["number"] as! Int
        }
        
        if let url = URL(string: "http://www.matapi.se/foodstuff/\(itemNumber)") {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                if let unwrappedData = data {
                    do {
                        let options = JSONSerialization.ReadingOptions()
                        if let parsedData = try JSONSerialization.jsonObject(with: unwrappedData, options: options) as? [String:Any] {
                            let cellNutrients = parsedData["nutrientValues"] as? [String:Any]
                            let cellKcal = cellNutrients!["energyKcal"] as! Int
                            cell.textLabel?.text = parsedData["name"] as? String
                            cell.detailTextLabel?.text = "Kalorier (kcal): \(cellKcal)"
                            cell.data = parsedData
                        } else {
                            print("ITEMINFO: Failed to parse json.")
                        }
                    } catch let error {
                        print("ITEMINFO: Error parsing json: \(error)")
                    }
                } else {
                    print("ITEMINFO: No data.")
                }
            }
            
            task.resume()
        }

    
        return cell
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
