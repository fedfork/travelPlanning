//
//  PlaceTableViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 15.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    static let reuseId = "PlaceTableViewCell"
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var adressLabel: UILabel!
    
    @IBOutlet var radioButton: UIButton!
    
    @IBAction func radioButtonTouched(_ sender: Any) {
        guard let indexPath = indexPath else {return}
        delegate?.tickObject(atIndexPath: indexPath)
        
    }
    
    var indexPath: IndexPath?
    var delegate: ShowAllPlacesViewControllerDelegate?
    
    var imageLight: UIImage?
    var imageDark: UIImage?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setValues (name: String, address: String, imageLight:UIImage?, imageDark:UIImage?, imageIsLight: Bool, indexPath: IndexPath) {
        nameLabel.text = name
        adressLabel.text = address
        self.indexPath = indexPath
        if imageIsLight {
            
            
            radioButton.setImage(imageLight, for: .normal)
        } else {
            
            
            radioButton.setImage(imageDark, for: .normal)
        }
    }
    

}
