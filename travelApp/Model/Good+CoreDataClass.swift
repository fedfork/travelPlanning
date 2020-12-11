//
//  Good+CoreDataClass.swift
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

@objc(Good)
public class Good: NSManagedObject {
    
    public static func fetchAllGoods(changed:Bool) -> [Good]?{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Good>(entityName: "Good")
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
    
    public static func addNewGoodToTrip(trip:Trip,  name: String, descript:String, isTaken: Bool, count: Int) -> Bool {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let goodEntity = NSEntityDescription.entity(forEntityName:"Good", in: managedContext) else {print("bad good entity");
            return false
        }
        let good = Good(entity: goodEntity, insertInto: managedContext)
        good.id = UUID().uuidString
        good.name = name
        good.descript = descript
        good.count = Int16(count)
        good.isTaken = isTaken
        good.userId = trip.userId
        
        good.wasChanged = true
        
        trip.triptogood = trip.triptogood?.adding(good) as NSSet?
        //marking trip as changed to include new place
        trip.wasChanged = true
        
        appDelegate.saveContext()
        return true
    }
    
    public static func editGood(good: Good, name: String, isTaken: Bool, descript:String, count: Int) -> Bool {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        good.name = name
        good.descript = descript
        good.count = Int16(count)
        good.isTaken = isTaken
        good.wasChanged = true
        
        appDelegate.saveContext()
        return true
    }
    
    public static func deleteGood(good: Good) -> Bool{
            
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext


        if DeletedObjectList.addDeletedEntity(ofType: "Good", entity: good.id!){
            
            managedContext.delete(good)
            appDelegate.saveContext()
            return true
        } else {
            
            print ("couldn't add deleted entity to deleted entities")
            return false
        }
}

    
    public static func syncGoods(syncInputJson: JSON) -> Bool{
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        // processing deleted
        for delGood in syncInputJson["deleted"]["goods"]{
            let fetchRequest = NSFetchRequest<Good>(entityName: "Good")
            
            let predicate1 = NSPredicate(format: "wasChanged == false")
            
            
            let predicate2 = NSPredicate(format: "id == %@", delGood.1["id"].stringValue)
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
        
        for chngGood in syncInputJson["updated"]["goods"]{
            // if was deleted, do nothing
            if DeletedObjectList.wasObjectDeleted(ofType: "Good", id: chngGood.1["id"].stringValue){
                continue
            }
            let fetchRequest = NSFetchRequest<Good>(entityName: "Good")
            fetchRequest.predicate = NSPredicate (format: "id == %@", chngGood.1["id"].stringValue)
            do {
                let fetchedResults = try managedContext.fetch(fetchRequest)
                
                if fetchedResults.count == 1 && !fetchedResults[0].wasChanged  {
                        //updating object
                        
                        fetchedResults[0].userId = chngGood.1["userId"].stringValue
                        fetchedResults[0].descript = chngGood.1["description"].stringValue
                        fetchedResults[0].name = chngGood.1["name"].stringValue
                        fetchedResults[0].isTaken = chngGood.1["isTook"].boolValue
                        fetchedResults[0].count = Int16(chngGood.1["count"].intValue)
                        fetchedResults[0].wasChanged = false
                        appDelegate.saveContext()
                } else if fetchedResults.count == 0 {
                    //adding object
                    guard let goodEntity = NSEntityDescription.entity(forEntityName:"Good", in: managedContext) else {print("bad good entity"); return false}
                    let good = Good(entity: goodEntity, insertInto: managedContext)
                    good.id = chngGood.1["id"].stringValue
                    good.userId = chngGood.1["userId"].stringValue
                    
                    good.descript = chngGood.1["description"].stringValue
                    good.name = chngGood.1["name"].stringValue
                    good.isTaken = chngGood.1["isTook"].boolValue
                    good.count = Int16(chngGood.1["count"].intValue)
                    good.wasChanged = false
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
        var goodJSON = JSON(["id":id, "userId":userId, "name":name, "description":descript, "isTook": isTaken, "count": count ])
        return goodJSON
    }
    
    static func markAllGoodsAsNotChanged() -> Bool{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Good>(entityName: "Good")
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
