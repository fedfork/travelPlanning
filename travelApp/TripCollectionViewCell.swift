//
//  TripCollectionViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 02.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class TripCollectionViewCell: UICollectionViewCell {
    static let reuseId = "TripCollectionViewCell"
    
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var dateFromLalel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    func update(for trip: Trip_) {
        tripNameLabel.text = trip.Name
        dateFromLalel.text = trip.getDateStringFromTo()
    }
    
    func initiateZeroes() {
        tripNameLabel.text = "0"
        dateFromLalel.text = "0"
        
    }
    
    

}
