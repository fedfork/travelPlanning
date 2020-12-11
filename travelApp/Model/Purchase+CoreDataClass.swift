//
//  Purchase+CoreDataClass.swift
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

@objc(Purchase)

public class Purchase: NSManagedObject {
    
    public static func fetchAllChangedPurchases() -> [Purchase]?{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Purchase>(entityName: "Purchase")
        fetchRequest.predicate = NSPredicate(format: "wasChanged == true")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            return fetchedResults
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
    }
    
    public func serializeToJSON() -> JSON{
        var purchaseJSON = JSON(["id":id, "userId":userId, "categoryId":categoryId, "name":name, "description":descript, "price": price, "isBought":isBought])
        return purchaseJSON
    }
    
    static func markAllPurchasesAsNotChanged() -> Bool{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Purchase>(entityName: "Purchase")
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
    
    public static func addNewPurchaseToTrip(trip:Trip,  name: String, descript:String, isBought: Bool, price: Double, categoryId: String) -> Bool {
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
              return false
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let purchaseEntity = NSEntityDescription.entity(forEntityName:"Purchase", in: managedContext) else {print("bad good entity");
                return false
            }
            let purchase = Purchase(entity: purchaseEntity, insertInto: managedContext)
            purchase.id = UUID().uuidString
            purchase.name = name
            purchase.descript = descript
            purchase.isBought = isBought
            purchase.userId = trip.userId
            purchase.price = price
            purchase.categoryId = categoryId
            purchase.wasChanged = true
        
            trip.triptopurchase = trip.triptopurchase?.adding(purchase) as NSSet?
            //marking trip as changed to include new place
            trip.wasChanged = true
            
            appDelegate.saveContext()
            return true
        }
        
    public static func editPurchase(purchase: Purchase, name: String, descript:String, isBought: Bool, price:Double, categoryId: String) -> Bool {
            
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
              return false
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            purchase.name = name
            purchase.descript = descript
            purchase.isBought = isBought
           
            purchase.price = price
            purchase.categoryId = categoryId
            purchase.wasChanged = true
        
            appDelegate.saveContext()
            return true
        }
        
        public static func deleteGoal(purchase: Purchase) -> Bool{
                
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
              return false
            }
            let managedContext = appDelegate.persistentContainer.viewContext


            if DeletedObjectList.addDeletedEntity(ofType: "Purchase", entity: purchase.id!){
                managedContext.delete(purchase)
                appDelegate.saveContext()
                return true
            } else {
                print ("couldn't add deleted entity to deleted entities")
                return false
            }
    }
    
}
