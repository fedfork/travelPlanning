//
//  place.swift
//  travelApp
//
//  Created by Fedor Korshikov on 05.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation

class Place_ {
    internal init(name: String, adress: String, Description: String, id: String, checked: Bool, userId: String) {
        self.checked = checked
        self.name = name
        self.adress = adress
        self.description = Description
        self.id = id
        self.userId = userId
    }
    var name: String
    var adress: String
    var description: String
    var id: String
    var checked: Bool
    var userId: String
}
