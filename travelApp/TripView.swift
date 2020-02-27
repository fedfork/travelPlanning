//
//  TripView.swift
//  travelApp
//
//  Created by Fedor Korshikov on 26.02.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class TripView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var tripName: UILabel!
    
    @IBOutlet weak var Description: UILabel!
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("TripView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
