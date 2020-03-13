//
//  HeaderCollectionReusableView.swift
//  travelApp
//
//  Created by Fedor Korshikov on 05.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let reuseId = "HeaderCollectionView"
    
    @IBOutlet var nameLabel: UILabel!
    func setupDesign()  {
        
        self.layer.cornerRadius = 20.0
        self.layer.masksToBounds = true;
        self.clipsToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        
    }
    
    func update(for header: String) {
        nameLabel.text = header
    }
    
    func initiateZeroes(){
        nameLabel.text = "0"
    }
    
}
