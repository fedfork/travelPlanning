//
//  Place+CoreDataProperties.swift
//  travelApp
//
//  Created by Fedor Korshikov on 29.05.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var adress: String?
    @NSManaged public var descript: String?
    @NSManaged public var checked: Bool
    @NSManaged public var placetotrip: Trip?

}
