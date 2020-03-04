//
//  Trip.swift
//  travelApp
//
//  Created by Fedor Korshikov on 28.02.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Trip {
    internal init(Id: String, Name: String, TextField: String) {
        self.Id = Id
        self.Name = Name
        self.TextField = TextField
    }
    
    var Id : String
    var Name : String
    var TextField : String
    
}
