//
//  PurchasesTableViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 03.12.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PurchasesTableViewCell: UITableViewCell {

    
    @IBOutlet var radioButton: UIButton!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var categoryLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    
    
    @IBAction func radioButtonClicked(_ sender: Any) {
        guard var checked = checked else {return}
        guard var indexPath = indexPath else {return}
        self.checked = !checked
        delegate?.cellCheckedUnchecked(indexPath: indexPath, checked: self.checked!)
        delegate?.updateWithFiltering()
        if self.checked! {
                   radioButton.setImage(imageChecked, for: .normal)
               } else {
                   radioButton.setImage(imageUnchecked, for: .normal)
               }
    }
    
    var imageUnchecked: UIImage?
    var imageChecked: UIImage?
    var checked: Bool?
    var delegate: PurchasesViewControllerDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFields(name: String, category: String, price:Double, checkedImage: UIImage?, uncheckedImage: UIImage?, checked: Bool, indexPath: IndexPath){
        nameLabel.text = name
        categoryLabel.text = category
        priceLabel.text = String(price)
        
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
