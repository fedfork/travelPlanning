//
//  PlaceCollectionViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 05.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var image: UIImageView!
    
    func update(for name: String, counter: Int, image: UIImage?) {
        placeName.text = name
        counterLabel.text = "\(counter)"
        self.image.image = image
    }
    
    func setupDesign()  {
        
        contentView.layer.cornerRadius = 20.0
        contentView.layer.masksToBounds = true;
        contentView.clipsToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
    }
    
}
