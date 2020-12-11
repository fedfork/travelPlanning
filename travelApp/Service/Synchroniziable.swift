//
//  Synchronisiable.swift
//  travelApp
//
//  Created by Fedor Korshikov on 20.07.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

protocol Synchroniziable{
    func syncObjectsOfEntity(ofType:String, syncInputJson:JSON) -> Bool
}
extension Synchroniziable {
    static public func syncObjectsOfEntity(ofType:String, syncInputJson:JSON) -> Bool{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var stringJsonName: String
        let stringName = ofType
        //creating entity
   
        switch ofType{
        case "Place":
            stringJsonName = "places"
        case "Good":
            stringJsonName = "goods"
        case "Goal":
            stringJsonName = "goals"
        case "Purchase":
            stringJsonName = "purchases"
        case "Trip":
            stringJsonName = "trips"
            //TODO: put new entity here
        default:
            print ("Unsupported type. Terminate")
            return false
        }
        
        // processing deleted
        
        for deletingObject in syncInputJson["deleted"][stringJsonName]{
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: stringName)
            
            let predicate1 = NSPredicate(format: "wasChanged == false")
            
            
            let predicate2 = NSPredicate(format: "id == %@", deletingObject.1["id"].stringValue)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
            
            do {
                let fetchedResults = try managedContext.fetch(fetchRequest)
                if fetchedResults.count == 1 {
                    switch ofType{
                           case "Place":
                               let place = fetchedResults[0] as! Place
                               managedContext.delete(place)
                           case "Good":
                               let good = fetchedResults[0] as! Good
                               managedContext.delete(good)
                           case "Goal":
                               let goal = fetchedResults[0] as! Goal
                               managedContext.delete(goal)
                           case "Purchase":
                               let purchase = fetchedResults[0] as! Purchase
                               managedContext.delete(purchase)
                           case "Trip":
                               let trip = fetchedResults[0] as! Trip
                               managedContext.delete(trip)
                        //TODO: put new entity here
                           default:
                               print ("Unsupported type. Terminate")
                               return false
                           }
                    appDelegate.saveContext()
                }
            } catch let error {
                print (error.localizedDescription)
                return false
            }
        }
        
        //putting changed to coredara
        for chngObject in syncInputJson["updated"][stringJsonName]{
            // if was deleted, do nothing
            if DeletedObjectList.wasObjectDeleted(ofType: ofType, id: chngObject.1["id"].stringValue){
                continue
            }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ofType)
            fetchRequest.predicate = NSPredicate (format: "id == %@", chngObject.1["id"].stringValue)
            switch ofType{
                case "Place":
                    do {
                        let fetchedResults = try managedContext.fetch(fetchRequest)
                        let placeResults = fetchedResults as! [Place]
                        if placeResults.count == 1 && !placeResults[0].wasChanged  {
                                //updating object
                                placeResults[0].adress = chngObject.1["adress"].stringValue
                                placeResults[0].userId = chngObject.1["userId"].stringValue
                                placeResults[0].checked = chngObject.1["isVisited"].boolValue
                                placeResults[0].date = Date(ticks: Int64(chngObject.1["date"].intValue))
                                placeResults[0].descript = chngObject.1["description"].stringValue
                                placeResults[0].name = chngObject.1["name"].stringValue
                                placeResults[0].wasChanged = false
                        } else if placeResults.count == 0 {
                            //adding object
                            guard let placeEntity = NSEntityDescription.entity(forEntityName:ofType, in: managedContext) else {print("bad place entity"); return false}
                            let place = Place(entity: placeEntity, insertInto: managedContext)
                            place.id = chngObject.1["id"].stringValue
                            place.userId = chngObject.1["userId"].stringValue
                            place.adress = chngObject.1["adress"].stringValue
                            place.checked = chngObject.1["isVisited"].boolValue
                            place.date = Date(ticks: Int64(chngObject.1["date"].intValue))
                            place.descript = chngObject.1["description"].stringValue
                            place.name = chngObject.1["name"].stringValue
                            place.wasChanged = false
                        }
                    } catch let error {
                        print (error.localizedDescription)
                        return false
                    }
                    appDelegate.saveContext()
                case "Good":
                    do {
                        let fetchedResults = try managedContext.fetch(fetchRequest)
                        let objectResults = fetchedResults as! [Good]
                        if objectResults.count == 1 && !objectResults[0].wasChanged  {
                                //updating object
                                objectResults[0].userId = chngObject.1["userId"].stringValue
                                objectResults[0].descript = chngObject.1["description"].stringValue
                                objectResults[0].name = chngObject.1["name"].stringValue
                                objectResults[0].isTaken = chngObject.1["isTook"].boolValue
                                objectResults[0].count = chngObject.1["count"].int16Value
                                objectResults[0].wasChanged = false
                        } else if objectResults.count == 0 {
                            //adding object
                            guard let objectEntity = NSEntityDescription.entity(forEntityName:ofType, in: managedContext) else {print("bad good entity"); return false}
                            let good = Good(entity: objectEntity, insertInto: managedContext)
                            good.id = chngObject.1["id"].stringValue
                            good.userId = chngObject.1["userId"].stringValue
                            good.isTaken = chngObject.1["isTook"].boolValue
                            good.count = chngObject.1["count"].int16Value
                            good.descript = chngObject.1["description"].stringValue
                            good.name = chngObject.1["name"].stringValue
                            good.wasChanged = false
                        }
                    } catch let error {
                        print (error.localizedDescription)
                        return false
                    }
                    appDelegate.saveContext()
                case "Goal":
                     do {
                       let fetchedResults = try managedContext.fetch(fetchRequest)
                       let objectResults = fetchedResults as! [Goal]
                       if objectResults.count == 1 && !objectResults[0].wasChanged  {
                               //updating object
                               objectResults[0].userId = chngObject.1["userId"].stringValue
                               objectResults[0].descript = chngObject.1["description"].stringValue
                               objectResults[0].name = chngObject.1["name"].stringValue
                               objectResults[0].isDone = chngObject.1["isDone"].boolValue
                               objectResults[0].wasChanged = false
                       } else if objectResults.count == 0 {
                           //adding object
                           guard let objectEntity = NSEntityDescription.entity(forEntityName:ofType, in: managedContext) else {print("bad good entity"); return false}
                           let goal = Goal(entity: objectEntity, insertInto: managedContext)
                           goal.id = chngObject.1["id"].stringValue
                           goal.userId = chngObject.1["userId"].stringValue
                           goal.isDone = chngObject.1["isDone"].boolValue
                           goal.descript = chngObject.1["description"].stringValue
                           goal.name = chngObject.1["name"].stringValue
                           goal.wasChanged = false
                       }
                   } catch let error {
                       print (error.localizedDescription)
                       return false
                   }
                   appDelegate.saveContext()
                case "Purchase":
                     do {
                          let fetchedResults = try managedContext.fetch(fetchRequest)
                          let objectResults = fetchedResults as! [Purchase]
                          if objectResults.count == 1 && !objectResults[0].wasChanged  {
                            //updating object
                            objectResults[0].userId = chngObject.1["userId"].stringValue
                            objectResults[0].descript = chngObject.1["description"].stringValue
                            objectResults[0].name = chngObject.1["name"].stringValue
                            objectResults[0].isBought = chngObject.1["isBought"].boolValue
                            objectResults[0].categoryId = chngObject.1["categoryId"].stringValue
                            objectResults[0].price = chngObject.1["price"].doubleValue
                            objectResults[0].wasChanged = false
                          } else if objectResults.count == 0 {
                              //adding object
                              guard let objectEntity = NSEntityDescription.entity(forEntityName:ofType, in: managedContext) else {print("bad purchase entity"); return false}
                              let purchase = Purchase(entity: objectEntity, insertInto: managedContext)
                              purchase.id = chngObject.1["id"].stringValue
                              purchase.userId = chngObject.1["userId"].stringValue
                              purchase.isBought = chngObject.1["isBought"].boolValue
                              purchase.categoryId = chngObject.1["categoryId"].stringValue
                              purchase.price = chngObject.1["price"].doubleValue
                              purchase.descript = chngObject.1["description"].stringValue
                              purchase.name = chngObject.1["name"].stringValue
                              purchase.wasChanged = false
                          }
                      } catch let error {
                          print (error.localizedDescription)
                          return false
                      }
                      appDelegate.saveContext()
                case "Trip":
                    do {
                        let fetchedResults = try managedContext.fetch(fetchRequest)
                        let objectResults = fetchedResults as! [Trip]
                        if objectResults.count == 1 && !objectResults[0].wasChanged  {
                            //updating object
                            objectResults[0].userId = chngObject.1["userId"].stringValue

                            objectResults[0].name = chngObject.1["name"].stringValue
                            objectResults[0].textField = chngObject.1["textField"].stringValue
                            objectResults[0].dateFrom = Date(ticks: chngObject.1["fromDate"].int64Value)
                            objectResults[0].dateTo = Date(ticks: chngObject.1["toDate"].int64Value)
                            objectResults[0].wasChanged = false
                            //iterating over Places to reconnect to them in coreData
                            for place in syncInputJson["updated"]["trips"][ objectResults[0].id! ]["placeIds"]{
                                let fetchRequest1:NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
                                fetchRequest1.predicate = NSPredicate(format: "id == %@", place.1.stringValue) //???
                                do {
                                    let fetchedResults = try managedContext.fetch(fetchRequest1)
                                    if fetchedResults.count == 1{                                    objectResults[0].triptoplace = objectResults[0].triptoplace?.adding(fetchedResults[0]) as NSSet?

                                    }
                                    
                                }
                                catch let error {
                                    print (error.localizedDescription)
                                    return false
                                }
                            }
                            //iterating over Purchases to reconnect to them in coreData
                            for purchase in syncInputJson["updated"]["trips"][ objectResults[0].id! ]["purchaseIds"]{
                                let fetchRequest1:NSFetchRequest<Purchase> = NSFetchRequest(entityName: "Purchase")
                                fetchRequest1.predicate = NSPredicate(format: "id == %@", purchase.1.stringValue) //???
                                do {
                                    let fetchedResults = try managedContext.fetch(fetchRequest1)
                                    if fetchedResults.count == 1{                                    objectResults[0].triptopurchase = objectResults[0].triptopurchase?.adding(fetchedResults[0]) as NSSet?

                                    }
                                    
                                }
                                catch let error {
                                    print (error.localizedDescription)
                                    return false
                                }
                            }
                            //iterating over Goals to reconnect to them in coreData
                            for goal in syncInputJson["updated"]["trips"][ objectResults[0].id! ]["goalIds"]{
                                let fetchRequest1:NSFetchRequest<Goal> = NSFetchRequest(entityName: "Goal")
                                fetchRequest1.predicate = NSPredicate(format: "id == %@", goal.1.stringValue) //???
                                do {
                                    let fetchedResults = try managedContext.fetch(fetchRequest1)
                                    if fetchedResults.count == 1{                                    objectResults[0].triptogoal = objectResults[0].triptogoal?.adding(fetchedResults[0]) as NSSet?

                                    }
                                    
                                }
                                catch let error {
                                    print (error.localizedDescription)
                                    return false
                                }
                            }
                            //iterating over Goods to reconnect to them in coreData
                            for good in syncInputJson["updated"]["trips"][ objectResults[0].id! ]["goodIds"]{
                                let fetchRequest1:NSFetchRequest<Good> = NSFetchRequest(entityName: "Good")
                                fetchRequest1.predicate = NSPredicate(format: "id == %@", good.1.stringValue) //???
                                do {
                                    let fetchedResults = try managedContext.fetch(fetchRequest1)
                                    if fetchedResults.count == 1{                                    objectResults[0].triptogood = objectResults[0].triptogood?.adding(fetchedResults[0]) as NSSet?

                                    }
                                    
                                }
                                catch let error {
                                    print (error.localizedDescription)
                                    return false
                                }
                            }
                            
                        } else if objectResults.count == 0 {
                            //adding object
                            guard let objectEntity = NSEntityDescription.entity(forEntityName:ofType, in: managedContext) else {print("bad purchase entity"); return false}
                            let trip = Trip(entity: objectEntity, insertInto: managedContext)
                            trip.id = chngObject.1["id"].stringValue
                            trip.userId = chngObject.1["userId"].stringValue
                            trip.name = chngObject.1["name"].stringValue
                            trip.wasChanged = false
                            trip.textField = chngObject.1["textField"].stringValue
                            trip.dateFrom = Date(ticks: chngObject.1["fromDate"].int64Value)
                            trip.dateTo = Date(ticks: chngObject.1["toDate"].int64Value)
                        
                        }
                        } catch let error {
                            print (error.localizedDescription)
                            return false
                        }
                        appDelegate.saveContext()
                
                //TODO: add new entities here
                default:
                    print ("Unsupported type. Terminate")
                    return false
            }
           
 
        }
        return true
    }
}
