//
//  GoodsViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 20.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class GoodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, refreshableDelegate {
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let strb = UIStoryboard(name: "Main", bundle: nil)
        let addGoodVC = strb.instantiateViewController(withIdentifier: "addGoodVC") as! AddGoodViewController
        addGoodVC.tripId = trip?.Id
        addGoodVC.delegate = self
        self.present(addGoodVC, animated: true, completion: nil)
        
    }
    @IBOutlet var tableView: UITableView!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var tripId: String?
    
    var goods = [Good] ()
    
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getTrip()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("goodsCount=\(goods.count)")
        return goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goodsTableViewCell") as! GoodsTableViewCell
        
        let currItem = goods[indexPath.item]
        if currItem.isTaken {
            cell.setChecked()
        } else {
            cell.setUnchecked()
        }
        cell.setLabel(withText: currItem.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkUncheckGood(good: goods[indexPath.item], numOfRow: indexPath)
    }
    
    func checkUncheckGood (good: Good, numOfRow: IndexPath){
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
            print ("ubable to read from the keychain")
            // display message
            return
        }
        guard let tripId = tripId else {print ("no trip id"); return}
        let myUrl1 = URL(string: GlobalConstants.apiUrl + "/good/upsert" + "?token=" + token)
        
        var request = URLRequest(url: myUrl1!)
        request.httpMethod = "POST"
        request.addValue ("application/json", forHTTPHeaderField: "content-type")
        var newGoodJson:JSON = [:]
        newGoodJson["id"] = JSON(good.id)
        newGoodJson["name"] = JSON(good.name)
        newGoodJson["description"] = JSON(good.description)
        newGoodJson["isTook"] = JSON(!good.isTaken)
        
         do {
                   request.httpBody = try newGoodJson.rawData()
               } catch {
                   print ("Error \(error). No request performed, terminating")
                   return
               }
                
                let group = DispatchGroup()
                group.enter()
                //performing request to get
                
                var errorFlag = false
                let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in

        //      self.removeActivityIndicator(activityIndicator: myActivityIndicator)

                    if error != nil || data == nil {
            //          self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                        errorFlag = true
                        
                        group.leave()
                        return
                    }
                    
                    let receivedJson = JSON(data!)
                    if !( receivedJson["id"].exists() ) {
                        
                        print ("new place json")
                        print (receivedJson)
                        errorFlag = true
                        
                    }
                    
                        group.leave()
                })
                
                task.resume()
                
                group.notify(queue: .main) {
                    // leaving current view controller
                    if !errorFlag {
                        
                        self.goods[numOfRow.item].isTaken = !self.goods[numOfRow.item].isTaken
                        var cell = self.tableView.cellForRow(at: numOfRow) as! GoodsTableViewCell
                        
                        if self.goods[numOfRow.item].isTaken {
                            cell.setChecked()
                        } else {
                            cell.setUnchecked()
                        }
                        self.tableView.deselectRow(at: numOfRow, animated: true)
                    } else {
                        print ("unable to save trip")
                        return
                    }
                }
                
    }
    
    func getTrip() {
              let tok = KeychainWrapper.standard.string(forKey: "accessToken")
                      guard let token = tok else {
                          print ("ubable to read from the keychain")
                          // display message
                          return
                      }
              guard let tripId = tripId else {print ("no trip id"); return}
              
              let myUrl1 = URL(string: GlobalConstants.apiUrl + "/trip/read?id=" + tripId + "&token=" + token)
            
            
            
                                  var tripReadRequest = URLRequest(url: myUrl1! )
                                  tripReadRequest.httpMethod = "GET"
                                  tripReadRequest.addValue ("application/json", forHTTPHeaderField: "content-type")
                                  
            let group = DispatchGroup()
            
            group.enter()
              let task2 = URLSession.shared.dataTask (with: tripReadRequest, completionHandler: { data2, response, error in
                  
                  if error != nil || data2 == nil {
                      print ("unable to retrieve trip " + tripId)
                      return
                  }
                  
//                        let tripJs = try? JSONSerialization.jsonObject(with: data2!, options: .mutableContainers) as? NSDictionary
                  
                  let tripJs = try? JSON(data: data2!)
                  guard let tripJson = tripJs else { print ("unable to parse trip's json of trip " + tripId); return}
                  
                  print (tripJson)
                  
                  //parsing places
                  var goodIds: [String] = []

                  
                  //reading trip's places

                  for (num,goodId):(String, JSON) in tripJson["goodIds"] {
                      guard let goodId = goodId.string else {continue}
                      goodIds.append(goodId)
                  }

                  
                let trip = Trip(Id: tripJson["id"].string ?? "", Name: tripJson["name"].string ?? "", TextField: tripJson["textField"].string ?? "", PlaceIds: [String](), goodIds: goodIds, timeFrom: tripJson["fromDate"].int64 ?? 0, timeTo: tripJson["toDate"].int64 ?? 0)
                  
                  self.trip = trip
         
//                        trip.getDateStringFromTo()
                  
                group.leave()
                
          })
        task2.resume()
        
        group.notify(queue: .main){
            self.loadGoods()
        }
    }
    
    func loadGoods () {
            let tok = KeychainWrapper.standard.string(forKey: "accessToken")
            guard let token = tok else {
                print ("ubable to read from the keychain")
    //            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                return
            }
            
            guard let currentTrip = trip else {print("no trip"); return}
        
        self.goods = [Good]()
        
            for goodId in currentTrip.goodIds
            {
                //created url with token
                let myUrl = URL(string: GlobalConstants.apiUrl + "/good/read?token="+token+"&id="+goodId)
                
                var request = URLRequest(url:myUrl!)
                
                request.httpMethod = "GET"
                request.addValue ("application/json", forHTTPHeaderField: "content-type")
                
                //performing request to get place
                let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in

        //                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)

                    if error != nil || data == nil {
        //                self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                        return
                    }

                    

                        //printing obtained string: for debugging
                        let dataStr = String(bytes: data!, encoding: .utf8)
                        print ("received data=\(dataStr!)")
                        
                        
        //                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as
                        
                        let good = try? JSON(data: data!)
                        
                        guard let goodJSON = good
                            else {
                                print ("unable to parse trip identifiers")
                                return
                        }
                    var newGood = Good (name: goodJSON["name"].string ?? "", description: goodJSON["description"].string ?? "", id: goodJSON["id"].string ?? "", isTaken: goodJSON["isVisited"].bool ?? false)
                        
                       
                    
                    
                    
                    self.goods.append(newGood)
                    self.reloadTableViewData()
                })
                task.resume()
                
                
        }
    }

    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func refresh() {
        getTrip()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
             if editingStyle == .delete {
                self.deleteGood(withId: goods[indexPath.item].id, positionInTable: indexPath)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
             }
        
    }
        func deleteGood (withId: String, positionInTable: IndexPath) {
            let tok = KeychainWrapper.standard.string(forKey: "accessToken")
            guard let token = tok else {
                print ("ubable to read from the keychain")
    //            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                return
            }
                    
                    
            var requestStr = GlobalConstants.apiUrl + "/good/delete?id="+withId+"&deletefromtrip=true"+"&token="+token
            
            
            
                    print (requestStr)
                    
                    let myUrl = URL(string: requestStr)
            //        print (myUrl)
                    
                    var request = URLRequest(url:myUrl!)
                    
                    request.httpMethod = "DELETE"
                    request.addValue ("application/json", forHTTPHeaderField: "content-type")

                    let group = DispatchGroup()
                    group.enter()
                    //performing request to get
            
                    var errorFlag = false
                    
                    let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in

            //                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                        if error != nil || data == nil {
                //          self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                            errorFlag = true
                            group.leave()
                            return
                        }
                        
                        let receivedJson = JSON (data!)
                        print (receivedJson)
                        
                        // закомментил, тк пока что метод почему то ничего не возвращает
    //                    if !( receivedJson["id"].exists() ) {
    //                        errorFlag = true
    //                    }
                        group.leave()
                    })
                    
                    task.resume()
            
            //deleting cell
            group.notify(queue: .main) {
                if !errorFlag {
                    self.goods.remove(at: positionInTable.item)
                    self.tableView.deleteRows(at: [positionInTable], with: .fade)
                }
            }
        }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
