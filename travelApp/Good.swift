//
//  Good.swift
//  travelApp
//
//  Created by Fedor Korshikov on 21.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation

class Good {
    internal init(name: String, description: String, id: String, isTaken: Bool) {
        self.name = name
        self.description = description
        self.id = id
        self.isTaken = isTaken
    }
    var name: String
    var description: String
    var id: String
    var isTaken: Bool
}
