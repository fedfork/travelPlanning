//
//  placeNoteCollectionViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 25.10.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class placeNoteCollectionViewCell: placeCollectionViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var text: UITextView!
    
    
    func setupLabels (name: String, text: String?){
        //TODO: set image
        self.name.text = name
        self.text.text = text ?? ""
    }
    
}
