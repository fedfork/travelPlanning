//
//  Trip+CoreDataProperties.swift
//  travelApp
//
//  Created by Fedor Korshikov on 29.05.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }
    
    

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var textField: String?
    @NSManaged public var dateFrom: Date?
    @NSManaged public var dateTo: Date?
    @NSManaged public var lastUpdate: Date?
    @NSManaged public var triptoplace: NSSet?
    @NSManaged public var triptogood: NSSet?
    @NSManaged public var triptogoal: NSSet?

}

// MARK: Generated accessors for triptoplace
extension Trip {

    @objc(addTriptoplaceObject:)
    @NSManaged public func addToTriptoplace(_ value: Place)

    @objc(removeTriptoplaceObject:)
    @NSManaged public func removeFromTriptoplace(_ value: Place)

    @objc(addTriptoplace:)
    @NSManaged public func addToTriptoplace(_ values: NSSet)

    @objc(removeTriptoplace:)
    @NSManaged public func removeFromTriptoplace(_ values: NSSet)

}

// MARK: Generated accessors for triptogood
extension Trip {

    @objc(addTriptogoodObject:)
    @NSManaged public func addToTriptogood(_ value: Good)

    @objc(removeTriptogoodObject:)
    @NSManaged public func removeFromTriptogood(_ value: Good)

    @objc(addTriptogood:)
    @NSManaged public func addToTriptogood(_ values: NSSet)

    @objc(removeTriptogood:)
    @NSManaged public func removeFromTriptogood(_ values: NSSet)

}

// MARK: Generated accessors for triptogoal
extension Trip {

    @objc(addTriptogoalObject:)
    @NSManaged public func addToTriptogoal(_ value: Goal)

    @objc(removeTriptogoalObject:)
    @NSManaged public func removeFromTriptogoal(_ value: Goal)

    @objc(addTriptogoal:)
    @NSManaged public func addToTriptogoal(_ values: NSSet)

    @objc(removeTriptogoal:)
    @NSManaged public func removeFromTriptogoal(_ values: NSSet)

}
