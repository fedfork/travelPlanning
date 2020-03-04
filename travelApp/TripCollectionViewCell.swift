//
//  TripCollectionViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 02.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class TripCollectionViewCell: UICollectionViewCell {
    static let reuseId = "TripCollectionViewCell"
    
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var dateFromLalel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(for trip: Trip) {
        tripNameLabel.text = trip.Name
        dateFromLalel.text = "jan1"
        dateToLabel.text = "jan8"
    }
    
    func initiateZeroes(){
        tripNameLabel.text = "0"
        dateFromLalel.text = "0"
        dateToLabel.text = "0"
    }


}
