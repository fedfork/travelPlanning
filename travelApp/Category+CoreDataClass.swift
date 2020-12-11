//
//  Category+CoreDataClass.swift
//  travelApp
//
//  Created by Fedor Korshikov on 03.12.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Category)
public class Category: NSManagedObject {
    public static func saveCategoriesFromJson (json: JSON?) {
        
        guard let json = json else {return}
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for category in json {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
        
            fetchRequest.predicate = NSPredicate(format: "id == %@", category.1["id"].stringValue)
            do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
                if fetchedResults.count == 0 {
                    guard let categoryEntity = NSEntityDescription.entity(forEntityName:"Category", in: managedContext) else {print("bad categort entity"); return }
                    let newCategory = Category(entity: categoryEntity, insertInto: managedContext)
                    newCategory.id = category.1["id"].stringValue
                    newCategory.name = category.1["name"].stringValue
                    newCategory.descript = category.1["description"].stringValue
                }
            }
                catch let error {
                    print (error.localizedDescription)
                    return
                }
            appDelegate.saveContext()
        }
        
    }
    
    public static func fetchAllCategories()-> [Category]? {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            return fetchedResults
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
    }
    
    public static func getCategoryNameById (id: String) -> String?{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if fetchedResults.count>0 {
                return fetchedResults[0].name
            } else {
                return nil
            }
            
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
        
    }
    
}
