//
//  CompareTableViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-03-04.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class CompareTableViewController: UITableViewController, UISearchResultsUpdating {

    var searchController : UISearchController!
    
    var searchResults : [[String:Any]] = []
    
    var tableItemsJson : [[String:Any]] = []
    
    var item1 : [String:Any] = [:]
    var item2 : [String:Any] = [:]
    
    var shouldUseSearchResult : Bool {
        return searchController.isActive && !(searchController.searchBar.text ?? "").isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Sök"
        searchController.searchBar.setValue("Avbryt", forKey: "_cancelButtonText")
        
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
            if text.characters.count >= 2 {
                searchResults = []
                for item in tableItemsJson {
                    let itemName = item["name"] as! String
                    if itemName.lowercased().contains(text) {
                        searchResults.append(item)
                    }
                }
                tableView.reloadData()
            } else {
                searchResults = []
                tableView.reloadData()
            }
        } else {
            searchResults = []
            tableView.reloadData()
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
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompareCell", for: indexPath) as! CustomTableViewCell
        let itemNumber = searchResults[indexPath.row]["number"] as! Int
        
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
        let compareVC = segue.destination as! ComparisonViewController
        compareVC.item1 = item1
        if let cell = sender as? CustomTableViewCell {
            compareVC.item2 = cell.data
        }
    }
}
