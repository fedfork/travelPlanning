//
//  SearchPlacesTableViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 22.10.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class SearchPlacesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var placeName: UILabel!
    
    
    @IBOutlet var addressLabell: UILabel!
    
    func setLabels (name: String, address: String){
        placeName.text = name
        addressLabell.text = address
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
