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
    
    public static func fetchAllChangedPlaces() -> [Place]?{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Place>(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "wasChanged == true")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            return fetchedResults
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
    }
    
    public static func syncPlaces(syncInputJson: JSON) -> [Place]?{
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
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
                return nil
            }
        }
        
        for chngPlace in syncInputJson["updated"]["places"]{
            // if was deleted, do nothing
            if UserDefaultsHelper.wasObjectDeleted(ofType: "Place", id: chngPlace.1["id"].stringValue){
                continue
            }
            let fetchRequest = NSFetchRequest<Place>(entityName: "Place")
            fetchRequest.predicate = NSPredicate (format: "id == %@", chngPlace.1["id"].stringValue)
            do {
                let fetchedResults = try managedContext.fetch(fetchRequest)
                if fetchedResults.count == 1 {
                    if !fetchedResults[0].wasChanged {
                        //updating object
                        fetchedResults[0].adress = chngPlace.1["adress"].stringValue
                        fetchedResults[0].checked = chngPlace.1["isVisited"].boolValue
                        fetchedResults[0].date = Date(ticks: Int64(chngPlace.1["date"].intValue))
                        fetchedResults[0].descript = chngPlace.1["desription"].stringValue
                        fetchedResults[0].name = chngPlace.1["name"].stringValue
                        appDelegate.saveContext()
                    }
                    
                }
            } catch let error {
                print (error.localizedDescription)
                return nil
            }
        }
        
        
        return nil
        
    }
    
    
    public func serializeToJSON() -> JSON{
        var placeJSON = JSON(["id":id, "userId":userId, "name":name, "description":descript, "adress": adress, "date": date!.ticks, "isVisited": checked ])
        return placeJSON
    }
    
  
}
