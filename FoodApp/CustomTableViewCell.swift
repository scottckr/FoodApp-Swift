//
//  CustomTableViewCell.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-02-21.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    var data : [String:Any] = [:]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
