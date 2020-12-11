//
//  Goal+CoreDataClass.swift
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

@objc(Goal)
public class Goal: NSManagedObject {

    public static func fetchAllChangedGoals() -> [Goal]?{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
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
        var goodJSON = JSON(["id":id, "userId":userId, "name":name, "description":descript, "isTook": isDone])
        return goodJSON
    }
    
    static func markAllGoalsAsNotChanged() -> Bool{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
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
    
        public static func addNewGoalToTrip(trip:Trip,  name: String, descript:String, isDone: Bool) -> Bool {
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
              return false
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let goalEntity = NSEntityDescription.entity(forEntityName:"Goal", in: managedContext) else {print("bad good entity");
                return false
            }
            let goal = Goal(entity: goalEntity, insertInto: managedContext)
            goal.id = UUID().uuidString
            goal.name = name
            goal.descript = descript
            goal.isDone = isDone
            goal.userId = trip.userId
            
            goal.wasChanged = true
            
            trip.triptogoal = trip.triptogoal?.adding(goal) as NSSet?
            //marking trip as changed to include new place
            trip.wasChanged = true
            
            appDelegate.saveContext()
            return true
        }
        
        public static func editGoal(goal: Goal, name: String, isDone: Bool, descript:String) -> Bool {
            
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
              return false
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            goal.name = name
            goal.descript = descript
            goal.isDone = isDone
            goal.wasChanged = true
            
            appDelegate.saveContext()
            return true
        }
        
        public static func deleteGoal(goal: Goal) -> Bool{
                
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
              return false
            }
            let managedContext = appDelegate.persistentContainer.viewContext


            if DeletedObjectList.addDeletedEntity(ofType: "Goal", entity: goal.id!){
                managedContext.delete(goal)
                appDelegate.saveContext()
                return true
            } else {
                print ("couldn't add deleted entity to deleted entities")
                return false
            }
    }
    
}
