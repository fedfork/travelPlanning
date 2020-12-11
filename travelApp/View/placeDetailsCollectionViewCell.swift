//
//  placeDetailsCollectionViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 25.10.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class placeDetailsCollectionViewCell: placeCollectionViewCell {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var descript: UILabel!
    
    
    
    func setupLabels (name: String, descript: String?, image: UIImage?){
        //TODO: set image
        self.name.text = name
        self.descript.text = descript ?? ""
        self.image.image = image
    }
    
    
}
