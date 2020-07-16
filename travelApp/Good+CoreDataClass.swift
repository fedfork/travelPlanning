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
    
    public static func fetchAllChangedGoods() -> [Good]?{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Good>(entityName: "Good")
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
        var goodJSON = JSON(["id":id, "userId":userId, "name":name, "description":descript, "isTook": isTaken, "count": count ])
        return goodJSON
    }

}
