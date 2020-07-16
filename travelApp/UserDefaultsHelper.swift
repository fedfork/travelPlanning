//
//  userDefaultsHelper.swift
//  travelApp
//
//  Created by Fedor Korshikov on 16.07.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserDefaultsHelper{
    // need to pass a String "Goal", "Trip", "Good", "Purchase", "Place"
    public static func getDeletedEntitiesList(ofType: String) -> [JSON]?{
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
        
        guard let dataArr = UserDefaults.standard.value(forKey: key) as? [Data] else { return [JSON]()}
        
        var jsonArr = [JSON]()
        for data in dataArr {
            jsonArr.append( JSON(data) )
        }
        
        return jsonArr
    }
    
    public static func addDeletedEntity (ofType: String, entity:JSON) -> Bool{
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
        var jsonArr = [JSON]()
        guard let rawEntity = try? entity.rawData() else { print ("couldn't serialize entity to raw"); return false}
        
        if var existingDataArr = UserDefaults.standard.value(forKey: key) as? [Data]{
            existingDataArr.append(rawEntity)
            UserDefaults.standard.setValue(existingDataArr, forKey: key)
            return true
        } else {
            var dataArr = [Data]()
            dataArr.append(rawEntity)
            UserDefaults.standard.setValue(dataArr, forKey: key)
            return true
        }
        
    }
}
