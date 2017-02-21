//
//  ViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-02-16.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var itemNameLabel: UILabel!

    var itemName: String = ""
    var itemNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        itemNameLabel.text = itemName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! InfoTableViewController
        detailVC.itemNumber = itemNumber
    }
}

