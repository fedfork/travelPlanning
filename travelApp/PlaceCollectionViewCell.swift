//
//  PlaceCollectionViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 05.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    func update(for place: Place) {
        placeName.text = place.name
    }
    
    
}
