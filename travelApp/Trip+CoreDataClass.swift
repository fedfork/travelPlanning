//
//  Trip+CoreDataClass.swift
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

@objc(Trip)
public class Trip: NSManagedObject {
    
    public static func fetchAllTrips(changed: Bool) -> [Trip]?{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
        if changed{
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
    
    public static func fetchTripById(id: String) -> Trip?{
            guard let appDelegate =
             UIApplication.shared.delegate as? AppDelegate else {
             return nil
           }
           let managedContext = appDelegate.persistentContainer.viewContext
           
           let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
               fetchRequest.predicate = NSPredicate(format: "id == %@", id)
           do {
               let fetchedResults = try managedContext.fetch(fetchRequest)
            if fetchedResults.count==1{
                return fetchedResults[0]
            }
            return nil
           } catch let error {
               print (error.localizedDescription)
               return nil
           }
       }
    
    public func serializeToJSON() -> JSON{
        var tripJSON = JSON(["id":id, "userId":userId, "name":name, "textField":textField, "dateFrom": dateFrom!.ticks, "dateTo": dateTo!.ticks ])
        
        //adding id's of places, goals, goods etc
        if let places = self.triptoplace {
            var placeIds: [String] = []
            for case let place as Place in places {
                placeIds.append(place.id!)
            }
            tripJSON["placeIds"] = JSON(placeIds)
        }
        
        if let goods = self.triptogood {
            var goodIds: [String] = []
           for case let good as Good in goods {
               goodIds.append(good.id!)
           }
           tripJSON["goodIds"] = JSON(goodIds)
        }
        
        if let goals = self.triptogoal {
            var goalIds: [String] = []
            for case let goal as Goal in goals {
              goalIds.append(goal.id!)
            }
            tripJSON["goalIds"] = JSON(goalIds)
        }
        
        if let purchases = self.triptopurchase {
            var purchaseIds: [String] = []
            for case let purchase as Purchase in purchases {
              purchaseIds.append(purchase.id!)
            }
            tripJSON["purchaseIds"] = JSON(purchaseIds)
        }
        
        return tripJSON
    }
    
    func getDateStringFromTo() -> String {
            
            let dateFormatterWoYear = DateFormatter()
            dateFormatterWoYear.dateFormat = "dd, MMM"
            let dateFormatterYear = DateFormatter()
            dateFormatterYear.dateFormat = " YYYY"
            var strDateFrom = String()
            var strDateTo = String()
            
            if let dateFrom = dateFrom {
                strDateFrom += dateFormatterWoYear.string(from: dateFrom)
            } else {
                strDateFrom += "..."
            }
            
            if let dateTo = dateTo {
                strDateTo += dateFormatterWoYear.string(from: dateTo)
            } else {
                strDateTo += "..."
            }
            
            
            
            labelpoint: if let dateFrom = dateFrom, let dateTo = dateTo {
                let calendar = Calendar.current
                guard let year1 = calendar.dateComponents([.year], from: dateFrom).year, let year2 = calendar.dateComponents([.year], from: dateTo).year else { break labelpoint}
                if year1 != year2 {
                    strDateFrom += dateFormatterYear.string(from: dateFrom)
                    strDateTo += dateFormatterYear.string(from: dateTo)
                }
            }
            
            return strDateFrom + " -> " + strDateTo
        }
        
}

