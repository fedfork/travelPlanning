//
//  GoodsTableViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 21.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class GoodsTableViewCell: UITableViewCell {


    @IBOutlet var radioButton: UIButton!
    
    @IBOutlet var nameLabel: UILabel!

    @IBAction func radioButtonPressed(_ sender: Any) {
        guard var checked = checked else {return}
        self.checked = !checked
        delegate?.valuesInCellChanged(checked: self.checked!, counter: counter!,  indexPath: indexPath!)
        if self.checked! {
                   radioButton.setImage(imageChecked, for: .normal)
               } else {
                   radioButton.setImage(imageUnchecked, for: .normal)
               }
        
    }
    
    @IBAction func minButtonPressed(_ sender: Any) {
        guard let counter = counter else {return }
        self.counter = counter - 1 > 0 ? counter - 1 : 1
        counterLabel.text = "\(self.counter!)"
        delegate?.valuesInCellChanged(checked: self.checked!, counter: self.counter!, indexPath: indexPath!)
        
    }
    @IBAction func plusButtonPressed(_ sender: Any) {
        counter = counter! + 1 < 101 ? counter! + 1 : 100
        counterLabel.text = "\(counter!)"
        delegate?.valuesInCellChanged(checked: checked!, counter: counter!, indexPath: indexPath!)
    }
    
    @IBOutlet var counterLabel: UILabel!
    
    var counter: Int?
    var imageUnchecked: UIImage?
    var imageChecked: UIImage?
    var checked: Bool?
    var delegate: GoodsViewControllerDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setFields(name: String, checkedImage: UIImage?, uncheckedImage: UIImage?, checked: Bool, counter: Int, indexPath: IndexPath){
        nameLabel.text = name
        imageChecked = checkedImage
        imageUnchecked = uncheckedImage
        self.checked = checked
        if checked {
            radioButton.setImage(imageChecked, for: .normal)
        } else {
            radioButton.setImage(imageUnchecked, for: .normal)
        }
        self.counter = counter
        counterLabel.text = "\(counter)"
        self.indexPath = indexPath
    }
    
}
