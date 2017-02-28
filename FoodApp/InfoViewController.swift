//
//  ViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-02-16.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    var itemInfo: [String:Any] = [:]
    var favoriteItems : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if UserDefaults.standard.object(forKey: "favoriteItems") != nil {
            favoriteItems = UserDefaults.standard.object(forKey: "favoriteItems") as! [[String : Any]]
        }
        itemNameLabel.text = itemInfo["name"] as! String?
        print(favoriteItems.count)
        checkFavorites()
    }
    
    func checkFavorites() {
        if favoriteItems.flatMap({$0["name"] as? String}).contains((itemInfo["name"] as? String)!) {
            addFavoriteButton.setTitle("Tillagd i favoriter", for: .disabled)
            addFavoriteButton.isEnabled = false
        } else {
            addFavoriteButton.setTitle("Lägg till i favoriter", for: .normal)
            addFavoriteButton.isEnabled = true
        }
    }

    @IBAction func addToFavorites(_ sender: UIButton) {
        favoriteItems.append(itemInfo)
        UserDefaults.standard.set(favoriteItems, forKey: "favoriteItems")
        UserDefaults.standard.synchronize()
        checkFavorites()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! InfoTableViewController
        detailVC.itemInfo = itemInfo
    }
}

