//
//  goalsViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 09.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import Foundation
import SwiftKeychainWrapper
import SwiftyJSON

class goalsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, refreshableDelegate
{
    func refresh() {
        getTrip()
    }
    
    
    var tripId: String?
    var goals = [Goal] ()
    var trip: Trip?
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let strb = UIStoryboard(name: "Main", bundle: nil)
        let addGoalVC = strb.instantiateViewController(withIdentifier: "addGoalVC") as! AddGoalViewController
        addGoalVC.tripId = tripId
        addGoalVC.delegate = self
        self.present(addGoalVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getTrip()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
    collectionView.addGestureRecognizer(longPressGesture)
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print (goals.count)
        return goals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goalsCell", for: indexPath as! IndexPath) as! GoalCollectionViewCell
        cell.setupDesign()
        if goals.count <= indexPath.item { print ("incorrect invocation of a cell"); cell.setLabel(withText: ""); return cell }
        var goal = goals[indexPath.item]
        cell.setLabel(withText: goal.name)
        if goal.isDone {
            cell.setChecked()
        } else {
            cell.setUnchecked()
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("!!!")
        print (indexPath.item)
        print (goals.count)
        checkUncheckGoal(goal: goals[indexPath.item], numOfRow: indexPath)
        return
    }
    
    func checkUncheckGoal (goal: Goal, numOfRow: IndexPath){
        var cell = self.collectionView.cellForItem(at: numOfRow) as! GoalCollectionViewCell
        
        
        if !(self.goals[numOfRow.item].isDone) {
            
            cell.setChecked()
        } else {
            cell.setUnchecked()
        }
        
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
            print ("ubable to read from the keychain")
            // display message
            return
        }
        guard let tripId = tripId else {print ("no trip id"); return}
        let myUrl1 = URL(string: GlobalConstants.apiUrl + "/goal/upsert" + "?token=" + token)
        
        var request = URLRequest(url: myUrl1!)
        request.httpMethod = "POST"
        request.addValue ("application/json", forHTTPHeaderField: "content-type")
        var newGoalJSON:JSON = [:]
        newGoalJSON["id"] = JSON(goal.id)
        newGoalJSON["name"] = JSON(goal.name)
        newGoalJSON["description"] = JSON(goal.description)
        newGoalJSON["isDone"] = JSON(!goal.isDone)
        
         do {
                   request.httpBody = try newGoalJSON.rawData()
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
                        
                    
                        print (receivedJson)
                        errorFlag = true
                        
                    }
                    
                        group.leave()
                })
                
                task.resume()
                
                group.notify(queue: .main) {
                    // leaving current view controller
                    if !errorFlag {
                        
                        
                    self.goals[numOfRow.item].isDone = !self.goals[numOfRow.item].isDone
                        
                        
                    } else {
                        print ("unable to save")
                      
                        
                        if self.goals[numOfRow.item].isDone {
                            cell.setChecked()
                        } else {
                            cell.setUnchecked()
                        }
                        
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
                      var goalIds: [String] = []

                      
                      //reading trip's places

                      for (num,goalId):(String, JSON) in tripJson["goalIds"] {
                          guard let goalId = goalId.string else {continue}
                          goalIds.append(goalId)
                      }

                      
                    let trip = Trip(Id: tripJson["id"].string ?? "", Name: tripJson["name"].string ?? "", TextField: tripJson["textField"].string ?? "", PlaceIds: [String](), goodIds: [String](), goalIds: goalIds, timeFrom: tripJson["fromDate"].int64 ?? 0, timeTo: tripJson["toDate"].int64 ?? 0)
                      
                      self.trip = trip
             
    //                        trip.getDateStringFromTo()
                    
                    group.leave()
                    
              })
            task2.resume()
            
            group.notify(queue: .main){
                self.loadGoals()
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // getTrip()
        collectionView.reloadData()
    }
    
    func loadGoals () {
        
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
            print ("ubable to read from the keychain")
        //            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
            return
        }

        guard let currentTrip = trip else {print("no trip"); return}
        
        self.goals = [Goal]()
        
        var group = DispatchGroup()
        print ("CTGI=")
        print (currentTrip.goalIds)
            for goalId in currentTrip.goalIds
            {
                group.enter()
                //created url with token
                let myUrl = URL(string: GlobalConstants.apiUrl + "/goal/read?token="+token+"&id="+goalId)
                
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
                        
                        let goal = try? JSON(data: data!)
                        
                        guard let goalJSON = goal
                            else {
                                print ("unable to parse trip identifiers")
                                return
                        }
                    var newGoal = Goal (name: goalJSON["name"].string ?? "", description: goalJSON["description"].string ?? "", id: goalJSON["id"].string ?? "", isDone: goalJSON["isDone"].bool ?? false)
                    
                    self.goals.append(newGoal)
                    group.leave()
                })
                
                group.notify(queue: .main){
                    
                    self.reloadCollectionViewData()
                }
                task.resume()
                
                
        }
    }
    
    func reloadCollectionViewData(){
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
    
    func deleteGoal (withId: String, atIndex: Int) {
            let tok = KeychainWrapper.standard.string(forKey: "accessToken")
            guard let token = tok else {
                print ("ubable to read from the keychain")
    //            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                return
            }
        
            var requestStr = GlobalConstants.apiUrl + "/goal/delete?id="+withId+"&deletefromtrip=true"+"&token="+token
        
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
                    self.goals.remove(at: atIndex)
                    self.collectionView.reloadData()
                }
            }
        }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
           if gesture.state != .ended {
               return
           }

           let p = gesture.location(in: self.collectionView)

           if let indexPath = self.collectionView.indexPathForItem(at: p) {
               // get the cell at indexPath (the one you long pressed)
               let cell = self.collectionView.cellForItem(at: indexPath)
               // we got current trip, now display q/alert about deleting
               
               
               
        
               let choiceAlert = UIAlertController(title: " Выберите действие", message: "", preferredStyle: .actionSheet)
               
            
            choiceAlert.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: {action in
                 self.editGoal(goal: self.goals[indexPath.item])
                } ) )
            
            choiceAlert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {action in
                self.deleteGoal(withId: self.goals[indexPath.item].id, atIndex: indexPath.item)
            } ) )
            
               choiceAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: {action in
                   self.dismiss(animated: true, completion: nil)
               }))
               self.present(choiceAlert, animated: true, completion: nil)
               
           } else {
               print("couldn't find index path")
           }
       }
    
    func editGoal(goal: Goal){
        
    }
    
    func addGoal(){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let yourWidth = collectionView.bounds.width - 30
        let yourHeight = yourWidth / 4
        
        return CGSize(width: yourWidth, height: yourHeight)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
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

