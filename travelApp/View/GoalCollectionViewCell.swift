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
    @IBOutlet var descLabel: UILabel!
    
    
    @IBAction func radioButtonPressed(_ sender: Any) {
        
        
        guard var checked = checked else {return}
        
        
        self.checked = !checked
        delegate?.cellCheckedUnchecked(checked: self.checked!, indexPath: indexPath!)
        if self.checked! {
                   radioButton.setImage(imageChecked, for: .normal)
               } else {
                   radioButton.setImage(imageUnchecked, for: .normal)
               }
        
    }
    var imageUnchecked: UIImage?
    var imageChecked: UIImage?
    var checked: Bool?
    var delegate: GoalsViewControllerDelegate?
    var indexPath: IndexPath?

    
 
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
        
        self.contentView.isUserInteractionEnabled = false
         
     }
    
    func setFields(name: String, desc: String, checkedImage: UIImage?, uncheckedImage: UIImage?, checked: Bool, indexPath: IndexPath){
        cellName.text = name
        descLabel.text = desc
        imageChecked = checkedImage
        imageUnchecked = uncheckedImage
        self.checked = checked
        if checked {
            radioButton.setImage(imageChecked, for: .normal)
        } else {
            radioButton.setImage(imageUnchecked, for: .normal)
        }
        self.indexPath = indexPath
    }
    
    
}
