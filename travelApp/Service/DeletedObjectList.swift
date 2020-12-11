//
//  userDefaultsHelper.swift
//  travelApp
//
//  Created by Fedor Korshikov on 16.07.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import SwiftyJSON

class DeletedObjectList{
    // need to pass a String "Goal", "Trip", "Good", "Purchase", "Place"
    public static func getDeletedEntities(ofType: String) -> [JSON]?{
        var key: String
        switch ofType {
        case "Trip":
            key = "deletedTrips"
        case "Good":
            key = "deletedGoods"
        case "Purchase":
            key = "deletedPurchases"
        case "Place":
            key = "deletedPlaces"
        case "Goal":
            key = "deletedGoals"
        default:
            print ("getDeletedEntityList():: Wrong type")
            return nil
        }
        
        guard let dataArr = UserDefaults.standard.object(forKey: key) as? [String] else { return [JSON]()}
        
        var jsonArr = [JSON]()
        for data in dataArr {
            jsonArr.append( JSON(data) )
        }
        
        return jsonArr
    }
    
    public static func addDeletedEntity (ofType: String, entity:String) -> Bool{
        var key: String
        switch ofType {
        case "Trip":
            key = "deletedTrips"
        case "Good":
            key = "deletedGoods"
        case "Purchase":
            key = "deletedPurchases"
        case "Place":
            key = "deletedPlaces"
        case "Goal":
            key = "deletedGoals"
        default:
            print ("addDeletedEntity():: Wrong type")
            return false
        }
    
        // type of entity was changed from json to string
        
//        guard let rawEntity = try? entity.rawData() else { print ("couldn't serialize entity to raw"); return false }
//
//        if var existingDataArr = UserDefaults.standard.value(forKey: key) as? [Data]{
//            existingDataArr.append(rawEntity)
//            UserDefaults.standard.setValue(existingDataArr, forKey: key)
//            return true
//        } else {
//            var dataArr = [Data]()
//            dataArr.append(rawEntity)
//            UserDefaults.standard.setValue(dataArr, forKey: key)
//            return true
//        }
        
        if var existingDataArr = UserDefaults.standard.object(forKey: key) as? [String]{
            existingDataArr.append(entity)
            UserDefaults.standard.setValue(existingDataArr, forKey: key)
            
            
            return true
        } else {
            var stringsArr = [String]()
            stringsArr.append(entity)
            UserDefaults.standard.setValue(stringsArr, forKey: key)
            
            
            return true
        }
        
        
    }
    
    public static func clearDeletedEntitiesLists() {
        UserDefaults.standard.removeObject(forKey: "deletedTrips")
        UserDefaults.standard.removeObject(forKey: "deletedGoods")
        UserDefaults.standard.removeObject(forKey: "deletedPurchases")
        UserDefaults.standard.removeObject(forKey: "deletedPlaces")
        UserDefaults.standard.removeObject(forKey: "deletedGoals")
    }
    
    public static func wasObjectDeleted (ofType: String, id: String) -> Bool{
        let list = getDeletedEntities(ofType: ofType)
        guard let delList = list else { return false }
        for object in delList {
            if object["id"].stringValue == id {
                return true
            }
        }
        return false
    }
    

}
