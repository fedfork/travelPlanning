//
//  place.swift
//  travelApp
//
//  Created by Fedor Korshikov on 05.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation

class Place {
    internal init(name: String, adress: String, Description: String, id: String) {
        self.name = name
        self.adress = adress
        self.Description = Description
        self.id = id
    }
    
    var name: String
    var adress: String
    var Description: String
    var id: String
}
