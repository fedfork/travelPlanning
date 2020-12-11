//
//  Goal+CoreDataProperties.swift
//  travelApp
//
//  Created by Fedor Korshikov on 29.05.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var descript: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var goaltotrip: Trip?

}
