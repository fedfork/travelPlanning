//
//  StorageCoordinator.swift
//  travelApp
//
//  Created by Fedor Korshikov on 29.05.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import SwiftyJSON
import CoreData

class StorageCoordinator {

    func synchroniseWithServer()->Bool  {
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
              print ("ubable to read from the keychain")
              return false
        }
        
        //getting managedobjectcontext
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        
        
        let syncGetURL = URL(string: Global.apiUrl + "/Synchronization/GetData?token=" + token + "&time=" + self.getLastSyncServerTime())
                
        var syncGetRequest = URLRequest(url: syncGetURL! )
        syncGetRequest.httpMethod = "GET"
        syncGetRequest.addValue ("application/json", forHTTPHeaderField: "content-type")
                                      
        
        var syncInpJson: JSON?
        let dispatchGroup1 = DispatchGroup()
        
        
        
        let getServerSyncJsonTask = URLSession.shared.dataTask (with: syncGetRequest, completionHandler: { data, response, error in
          
            if error != nil || data == nil {
              print ("unable to retrieve sync json " )
              return
            }
            
            

            let tripJs = try? JSON(data: data!)
            guard let syncInpJs = tripJs else { print ("unable to parse sync input json"); return}
            
            syncInpJson = syncInpJs
            
            //check whether this json is correct
            
            
                                          
                                          //reading trip's places

//                                          for (num,placeId):(String, JSON) in tripJson["placeIds"] {
//                                              guard let placeId = placeId.string else {continue}
//                                              placeIds.append(placeId)
//                                          }
//
//
//                                        let trip = Trip(Id: tripJson["id"].string ?? "", Name: tripJson["name"].string ?? "", TextField: tripJson["textField"].string ?? "", PlaceIds: placeIds, goodIds: [String](), goalIds: [String](), timeFrom: tripJson["fromDate"].int64 ?? 0, timeTo: tripJson["toDate"].int64 ?? 0)
//
//                                          self.trip = trip
//
//                  //                        trip.getDateStringFromTo()
//
//                                        group.leave()
//
//                                      })
//                                      task2.resume()
//              }
//
//            func deletePlace (withId: String, positionInTable: IndexPath) {
//                 let tok = KeychainWrapper.standard.string(forKey: "accessToken")
//                        guard let token = tok else {
//                            print ("ubable to read from the keychain")
//                //            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
//                            return
//                        }
//
//
//                var requestStr = Global.apiUrl + "/place/delete?id="+withId+"&deletefromtrip=true"+"&token="+token
//
//
//
//                        print (requestStr)
//
//                        let myUrl = URL(string: requestStr)
//                //        print (myUrl)
//
//                        var request = URLRequest(url:myUrl!)
//
//                        request.httpMethod = "DELETE"
//                        request.addValue ("application/json", forHTTPHeaderField: "content-type")
//
//                        let group = DispatchGroup()
//                        group.enter()
//                        //performing request to get
//
//                        var errorFlag = false
//
//                        let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in
//
//                //                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
//                            if error != nil || data == nil {
//                    //          self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
//                                errorFlag = true
//                                group.leave()
//                                return
//                            }
//
//                            let receivedJson = JSON (data!)
//                            print (receivedJson)
//
//                            // закомментил, тк пока что метод почему то ничего не возвращает
//        //                    if !( receivedJson["id"].exists() ) {
//        //                        errorFlag = true
//        //                    }
//                            group.leave()
            dispatchGroup1.leave()
                        })
        
        dispatchGroup1.enter()
        
        //выполняем запрос json-а с сервера, ждем
        DispatchQueue.global(qos: .default).async{
            getServerSyncJsonTask.resume()
        }
        dispatchGroup1.wait ()
        
        // check if server-json-request ended the right way
        guard let syncInpJSON = syncInpJson else { print ("no json received"); return false}
        if !syncInpJSON["updated"].exists() { print ("bad json received"); return false }
        
        
        // creating json to send
        var localChangesJSON = JSON(["update":"","delete":""])
        localChangesJSON["update"] = JSON(["trips":"","goods":"","goals":"","places":"","purchases":""])
        localChangesJSON["delete"] = JSON(["tripIds":"","goodIds":"","goalIds":"","placeIds":"","purchaseIds":""])
        
        print (localChangesJSON)
        
        // fetching all changed trips, converting then into JSON array and adding to localChangesJSON
        guard let changedTrips = Trip.fetchAllChangedTrips() else { print ("didnt get changed trips array"); return false }
        var changedTripJSONs: [JSON] = []
        
        for changedTrip in changedTrips {
            changedTripJSONs.append ( changedTrip.serializeToJSON() )
        }
        
        localChangesJSON["update"]["trips"] = JSON (changedTripJSONs)
        
        
        // fetching all changed places, converting then into JSON array and adding to localChangesJSON
        guard let changedPlaces = Place.fetchAllChangedPlaces() else { print ("didnt get changed places array"); return false }
        var changedPlacesJSONs: [JSON] = []
        
        for changedPlace in changedPlaces {
            changedPlacesJSONs.append ( changedPlace.serializeToJSON() )
        }
        
        localChangesJSON["update"]["places"] = JSON (changedPlacesJSONs)
        
        
        // fetching all changed goods, converting then into JSON array and adding to localChangesJSON
        guard let changedGoods = Good.fetchAllChangedGoods() else { print ("didnt get changed goods array"); return false }
        var changedGoodsJSONs: [JSON] = []
        
        for changedGood in changedGoods {
            changedGoodsJSONs.append ( changedGood.serializeToJSON() )
        }
        
        localChangesJSON["update"]["goods"] = JSON (changedGoodsJSONs)
        
        
        // fetching all changed goals, converting then into JSON array and adding to localChangesJSON
        guard let changedGoals = Goal.fetchAllChangedGoals() else { print ("didnt get changed goals array"); return false }
        var changedGoalsJSONs: [JSON] = []
        
        for changedGoal in changedGoals {
            changedGoalsJSONs.append ( changedGoal.serializeToJSON() )
        }
        
        localChangesJSON["update"]["goals"] = JSON (changedGoalsJSONs)
        
        
        // fetching all changed purchases, converting then into JSON array and adding to localChangesJSON
        guard let changedPurchases = Purchase.fetchAllChangedPurchases() else { print ("didnt get changed goals array"); return false }
        var changedPurchasesJSONs: [JSON] = []
        
        for changedPurchase in changedPurchases {
            changedPurchasesJSONs.append ( changedPurchase.serializeToJSON() )
        }
        
        localChangesJSON["update"]["purchases"] = JSON (changedPurchasesJSONs)
        
        // getting deleted entities lists and adding them to JSON
        
        if let deletedTrips = UserDefaults.standard.array(forKey: "deletedTrips")  {
            localChangesJSON["delete"]["tripIds"] = JSON ( deletedTrips )
        }
        
        if let deletedPlaces = UserDefaults.standard.array(forKey: "deletedPlaces") {
            localChangesJSON["delete"]["placeIds"] = JSON ( deletedPlaces )
        }
        
        if let deletedGoods = UserDefaults.standard.array(forKey: "deletedGoods") {
            localChangesJSON["delete"]["goodIds"] = JSON ( deletedGoods )
        }
        
        if let deletedGoals = UserDefaults.standard.array(forKey: "deletedGoals")  {
            localChangesJSON["delete"]["goalIds"] = JSON ( deletedGoals )
        }
        
        if let deletedPurchases = UserDefaults.standard.array(forKey: "deletedPurchases") {
            localChangesJSON["delete"]["purchaseIds"] = JSON ( deletedPurchases )
        }
        
        // sending localChangesJSON to server
        
        let syncSendURL = URL(string: Global.apiUrl + "/Synchronization/SetData?token=" + token)
                
        var syncSendRequest = URLRequest(url: syncSendURL! )
        syncSendRequest.httpMethod = "POST"
        syncSendRequest.addValue ("application/json", forHTTPHeaderField: "content-type")
                                      
        
        let dispatchGroup2 = DispatchGroup()
        
        var respJson = JSON ("")
        
        let sendLocalChangesJsonTask = URLSession.shared.dataTask (with: syncGetRequest, completionHandler: { data, response, error in
          
            if error != nil || data == nil {
              print ("unable to retrieve sync json " )
              return
            }
            
            

            let servRespJson = try? JSON(data: data!)
            guard let respJs = servRespJson else { print ("unable to parse server response json"); return}
            
            respJson = respJs
        
//        var trips: [Trip]
//
//        let fetchTripsRequest = NSFetchRequest<Trip>(entityName:"Trip")
//        do {
//             trips = try managedContext.fetch(fetchTripsRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//
//        }
//        print (trips)
//
//
//
//        // working on trips that were updated on server
//        if updatedJson["trips"].exists() {
//            for (name,tripJson):(String, JSON) in updatedJson["trips"]
//            {
//                do {
//                     trips = try managedContext.fetch(fetchTripsRequest)
//                } catch let error as NSError {
//                    print("Could not fetch. \(error), \(error.userInfo)")
//                    return
//                }
//            }
//        }
        
            dispatchGroup2.leave()
        })
        
        dispatchGroup2.enter()
        
        DispatchQueue.global(qos: .default).async{
            sendLocalChangesJsonTask.resume()
        }
        dispatchGroup2.wait()
        
        if !respJson["update"].exists() { print ("wrong answer while trying to set data"); return false}
        
        // putting changes into coredata
        
        
        
        return true
    }
    
    func getServerTime() -> String{
        
        
        let servTimeReqUrl = URL(string: Global.apiUrl + "/Synchronization/GetServerTime")
                
        var servTimeReq = URLRequest(url: servTimeReqUrl! )
        servTimeReq.httpMethod = "GET"
        servTimeReq.addValue ("application/json", forHTTPHeaderField: "content-type")
                                      
        
        var servTime: String?
        let dispatchGroup1 = DispatchGroup()
        
        
        
        let getServerSyncJsonTask = URLSession.shared.dataTask (with: servTimeReq, completionHandler: { data, response, error in
          
            if error != nil || data == nil {
              print ("unable to retrieve sync json " )
              return
            }
            
            
            servTime = String(decoding: data!, as: UTF8.self)
            
            //check whether this json is correct
            
            
            dispatchGroup1.leave()
            })
        
        dispatchGroup1.enter()
        
        //выполняем запрос json-а с сервера, ждем
        DispatchQueue.global(qos: .default).async{
            getServerSyncJsonTask.resume()
        }
        dispatchGroup1.wait ()
        
        return servTime ?? ""
    }
    
    func getServerSyncJSON(time: String)->JSON {
        
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
              print ("ubable to read from the keychain")
              return false
        }
        
        
       let syncGetURL = URL(string: Global.apiUrl + "/Synchronization/GetData?token=" + token + "&time=" + time)
               
       var syncGetRequest = URLRequest(url: syncGetURL! )
       syncGetRequest.httpMethod = "GET"
       syncGetRequest.addValue ("application/json", forHTTPHeaderField: "content-type")
                                     
       
       var syncInpJson: JSON?
       let dispatchGroup1 = DispatchGroup()
       
       
       
        let dispatchgroup = DispatchGroup()
       let getServerSyncJsonTask = URLSession.shared.dataTask (with: syncGetRequest, completionHandler: { data, response, error in
         
           if error != nil || data == nil {
             print ("unable to retrieve sync json " )
             return
           }
           
           

           let tripJs = try? JSON(data: data!)
           guard let syncInpJs = tripJs else { print ("unable to parse sync input json"); return}
           
           syncInpJson = syncInpJs
        dispatchgroup.leave()
        })
        
        dispatchgroup.enter()
        
        DispatchQueue.global(qos: .default).async{
            getServerSyncJsonTask.resume()
        }
        dispatchgroup.wait()
        
        return syncInpJson ?? JSON()
    }
    
    func getLastSyncServerTime()->String {
        return UserDefaults.standard.string(forKey: "lastSyncServerTime") ?? "0"
    }
}
