//
//  Goal.swift
//  travelApp
//
//  Created by Fedor Korshikov on 09.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation

class Goal{
    internal init( name: String, description: String, id: String, isDone: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.isDone = isDone
    }
    
    var id: String
    var name: String
    var description: String
    var isDone: Bool
    
}
