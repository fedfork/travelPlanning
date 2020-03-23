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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUnchecked(){
        radioButton.setImage(UIImage(named:"not-pressed-rb.png"), for: .normal)
    }
    
    func setChecked(){
        radioButton.setImage(UIImage(named:"pressed-rb.png"), for: .normal)
    }
    
    func setLabel(withText: String){
        nameLabel.text = withText
    }
    
}
