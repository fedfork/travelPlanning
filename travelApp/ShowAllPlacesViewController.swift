//
//  ShowAllPlacesViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 15.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class ShowAllPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, refreshableDelegate {
    
    
    
    var tripId: String?
    
    var trip: Trip? {
        didSet
        {
            loadPlaces()
        }
    }
    
    var places: [Place] = [Place]()

    @IBOutlet var tableView: UITableView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getTrip()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadPlaces()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presentPlaceVC(inMode: .add, place: nil)
    }
    

    // configure tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
        if indexPath.item >= places.count { cell.setValues(name: "", address: ""); return cell }
        let place = places[indexPath.item]
        cell.setValues(name: place.name, address: place.adress)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // instantiate and present places view controller in show mode
        if indexPath.item >= places.count {
            print ("no such place")
            return
        }
        let place = places[indexPath.item]
        presentPlaceVC(inMode: .show, place: place)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            self.deletePlace(withId: places[indexPath.item].id, positionInTable: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .fade)
         }
        
        
    }
    
    // finished configuring table view
    
    func loadPlaces () {
            
            let tok = KeychainWrapper.standard.string(forKey: "accessToken")
            guard let token = tok else {
                print ("ubable to read from the keychain")
    //            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                return
            }
            
            guard let currentTrip = trip else {print("no trip"); return}
                
            places = [Place]()
            
            for placeId in currentTrip.PlaceIds
            {
                //created url with token
                let myUrl = URL(string: GlobalConstants.apiUrl + "/place/read?token="+token+"&id="+placeId)
                
                var request = URLRequest(url:myUrl!)
                
                request.httpMethod = "GET"
                request.addValue ("application/json", forHTTPHeaderField: "content-type")
                
                var places = [Place] ()
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
                        
                        let place = try? JSON(data: data!)
                        
                        guard let placeJSON = place
                            else {
                                print ("unable to parse trip identifiers")
                                return
                        }
                    var newPlace = Place(name: placeJSON["name"].string ?? "", adress: placeJSON["adress"].string ?? "", Description: placeJSON["description"].string ?? "", id: placeJSON["id"].string ?? "", checked: placeJSON["isVisited"].bool ?? false, userId: placeJSON["userId"].string ?? "")
                    
                    
                    
                    self.places.append (newPlace)
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
    
    
    
    func presentPlaceVC (inMode: AddPlaceViewController.PlaceControllerStates, place: Place?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let placeVC = storyboard.instantiateViewController(identifier: "placeVC") as! AddPlaceViewController
        
        placeVC.state = inMode
        
        if inMode != .add {
            placeVC.place = place
        } else {
            placeVC.tripId = tripId
        }
        
        placeVC.delegate = self
        
        self.present(placeVC, animated: true, completion: nil)
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
                                  var placeIds: [String] = []
    
                                  
                                  //reading trip's places

                                  for (num,placeId):(String, JSON) in tripJson["placeIds"] {
                                      guard let placeId = placeId.string else {continue}
                                      placeIds.append(placeId)
                                  }

                                  
                                let trip = Trip(Id: tripJson["id"].string ?? "", Name: tripJson["name"].string ?? "", TextField: tripJson["textField"].string ?? "", PlaceIds: placeIds, goodIds: [String](), goalIds: [String](), timeFrom: tripJson["fromDate"].int64 ?? 0, timeTo: tripJson["toDate"].int64 ?? 0)
                                  
                                  self.trip = trip
                         
          //                        trip.getDateStringFromTo()
                                  
                                group.leave()
                                
                              })
                              task2.resume()
      }
    
    func deletePlace (withId: String, positionInTable: IndexPath) {
         let tok = KeychainWrapper.standard.string(forKey: "accessToken")
                guard let token = tok else {
                    print ("ubable to read from the keychain")
        //            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                    return
                }
                
                
        var requestStr = GlobalConstants.apiUrl + "/place/delete?id="+withId+"&deletefromtrip=true"+"&token="+token
        
        
        
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
                self.places.remove(at: positionInTable.item)
                self.tableView.deleteRows(at: [positionInTable], with: .fade)
                
            }
        }
    }
    
    func refresh() {
        getTrip()
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

protocol refreshableDelegate {
    func refresh()
}
