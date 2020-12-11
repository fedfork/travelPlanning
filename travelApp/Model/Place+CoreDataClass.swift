//
//  Place+CoreDataClass.swift
//  travelApp
//
//  Created by Fedor Korshikov on 01.06.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON

@objc(Place)
public class Place: NSManagedObject {
    
    public static func fetchAllPlaces(changed: Bool) -> [Place]?{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Place>(entityName: "Place")
        if changed {
            fetchRequest.predicate = NSPredicate(format: "wasChanged == true")
        }
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            return fetchedResults
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
    }
    
    public static func deletePlace(place: Place) -> Bool{
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
//        let fetchRequest = NSFetchRequest<Place>(entityName: "Place")
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
//        do {
//            let fetchedResults = try managedContext.fetch(fetchRequest)
//            let place = fetchedResults[0]
//            managedContext.delete(place)
//        } catch let error {
//            print(error.localizedDescription)
//            return false
//        }
//        return true
        
        if DeletedObjectList.addDeletedEntity(ofType: "Place", entity: place.id!){
            managedContext.delete(place)
            appDelegate.saveContext()
            return true
        } else {
            print ("couldn't add deleted entity to deleted entities")
            return false
        }
    }
    
    public static func syncPlaces(syncInputJson: JSON) -> Bool {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        // processing deleted
        for delPlace in syncInputJson["deleted"]["places"]{
            let fetchRequest = NSFetchRequest<Place>(entityName: "Place")
            
            let predicate1 = NSPredicate(format: "wasChanged == false")
            
            
            let predicate2 = NSPredicate(format: "id == %@", delPlace.1["id"].stringValue)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
            
            do {
                let fetchedResults = try managedContext.fetch(fetchRequest)
                if fetchedResults.count == 1 {
                    managedContext.delete(fetchedResults[0])
                    appDelegate.saveContext()
                }
            } catch let error {
                print (error.localizedDescription)
                return false
            }
        }
        
        for chngPlace in syncInputJson["updated"]["places"]{
            // if was deleted, do nothing
            if DeletedObjectList.wasObjectDeleted(ofType: "Place", id: chngPlace.1["id"].stringValue){
                continue
            }
            let fetchRequest = NSFetchRequest<Place>(entityName: "Place")
            fetchRequest.predicate = NSPredicate (format: "id == %@", chngPlace.1["id"].stringValue)
            do {
                let fetchedResults = try managedContext.fetch(fetchRequest)
                
                if fetchedResults.count == 1 && !fetchedResults[0].wasChanged  {
                        //updating object
                        fetchedResults[0].adress = chngPlace.1["adress"].stringValue
                        fetchedResults[0].userId = chngPlace.1["userId"].stringValue
                        fetchedResults[0].checked = chngPlace.1["isVisited"].boolValue
                        fetchedResults[0].date = Date(ticks: Int64(chngPlace.1["date"].intValue))
                        fetchedResults[0].descript = chngPlace.1["description"].stringValue
                        fetchedResults[0].name = chngPlace.1["name"].stringValue
                        fetchedResults[0].wasChanged = false
                        appDelegate.saveContext()
                } else if fetchedResults.count == 0 {
                    //adding object
                    guard let placeEntity = NSEntityDescription.entity(forEntityName:"Place", in: managedContext) else {print("bad place entity"); return false}
                    let place = Place(entity: placeEntity, insertInto: managedContext)
                    place.id = chngPlace.1["id"].stringValue
                    place.userId = chngPlace.1["userId"].stringValue
                    place.adress = chngPlace.1["adress"].stringValue
                    place.checked = chngPlace.1["isVisited"].boolValue
                    place.date = Date(ticks: Int64(chngPlace.1["date"].intValue))
                    place.descript = chngPlace.1["description"].stringValue
                    place.name = chngPlace.1["name"].stringValue
                    place.wasChanged = false
                    appDelegate.saveContext()
                }
            } catch let error {
                print (error.localizedDescription)
                return false
            }
        }
        
        return true
        
    }
    
    
    public func serializeToJSON() -> JSON{
        var placeJSON = JSON(["id":id, "userId":userId, "name":name, "description":descript, "adress": adress, "date": date!.ticks, "isVisited": checked ])
        return placeJSON
    }
    
    public static func addNewPlaceToTrip(trip:Trip, userId: String, adress: String, checked: Bool, date: Date, description:String, name: String, phone: String?) -> Bool {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let placeEntity = NSEntityDescription.entity(forEntityName:"Place", in: managedContext) else {print("bad place entity"); return false}
        let place = Place(entity: placeEntity, insertInto: managedContext)
        place.id = UUID().uuidString
        place.userId = userId
        place.adress = adress
        place.checked = checked
        place.date = date
        place.descript = description
        place.name = name
        place.wasChanged = true
        place.phone = phone
        
        trip.triptoplace = trip.triptoplace?.adding(place) as NSSet?
        //marking trip as changed to include new place
        trip.wasChanged = true
        
        appDelegate.saveContext()
        
        return true
    }
    
    public static func editPlace(place: Place, adress: String, checked: Bool, date: Date, description:String, name: String, phone: String?) -> Bool {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        place.adress = adress
        place.checked = checked
        place.date = date
        place.descript = description
        place.name = name
        place.phone = phone
        place.wasChanged = true
        
        appDelegate.saveContext()
        return true
    }
    
    static func markAllPlacesAsNotChanged() -> Bool{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Place>(entityName: "Place")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for result in fetchedResults {
                result.wasChanged = false
            }
            appDelegate.saveContext()
        } catch let error {
            print (error.localizedDescription)
            return false
        }
        return true
    }
    
    
  
}
