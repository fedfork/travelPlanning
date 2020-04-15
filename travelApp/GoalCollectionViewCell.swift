//
//  GoalCollectionViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 09.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class GoalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var cellName: UILabel!
    @IBOutlet var radioButton: UIButton!
    
    func setUnchecked(){
        radioButton.setImage(UIImage(named:"not-pressed-rb.png"), for: .normal)
    }
    
    func setChecked(){
        radioButton.setImage(UIImage(named:"pressed-rb.png"), for: .normal)
    }
    
    func setLabel(withText: String){
        cellName.text = withText
    }
    
    func setupDesign()  {
         
         contentView.layer.cornerRadius = 20
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
