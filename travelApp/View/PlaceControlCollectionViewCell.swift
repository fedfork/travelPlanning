//
//  PlaceControlCollectionViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 03.11.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PlaceControlCollectionViewCell: placeCollectionViewCell {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var label: UILabel!
    
    func setupLabels (name: String, image: UIImage?, color: UIColor){
        self.label.text = name
        self.label.textColor = color
        self.image.image = image
    }
    
}
