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
    
}
