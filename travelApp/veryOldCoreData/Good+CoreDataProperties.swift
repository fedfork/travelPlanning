//
//  Good+CoreDataProperties.swift
//  travelApp
//
//  Created by Fedor Korshikov on 29.05.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Good {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Good> {
        return NSFetchRequest<Good>(entityName: "Good")
    }

    @NSManaged public var name: String?
    @NSManaged public var desript: String?
    @NSManaged public var id: String?
    @NSManaged public var isTaken: Bool
    @NSManaged public var amount: Int16
    @NSManaged public var goodtotrip: Trip?

}
