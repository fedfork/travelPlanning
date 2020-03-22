//
//  PlaceTableViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 15.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    static let reuseId = "PlaceTableViewCell"
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var adressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setValues (name: String, address: String) {
        nameLabel.text = name
        adressLabel.text = address
    }
    

}
