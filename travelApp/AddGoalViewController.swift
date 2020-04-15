//
//  AddGoalViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 09.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class AddGoalViewController: UIViewController {

    var delegate: refreshableDelegate?
    var goal: Good?
    var tripId: String?
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var descriptionField: UITextView!
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        addGoalAndLeave()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        delegate?.refresh()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     func addGoalAndLeave() {
                
            var goal = Goal(name: nameField.text ?? "", description: "", id: "", isDone: false)
                    
                    
                
                guard let tripId = tripId else { print ("bad trip"); return }
                
                let tok = KeychainWrapper.standard.string(forKey: "accessToken")
                guard let token = tok else {
                    print ("ubable to read from the keychain")
        //            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                    return
                }
                
                
                var requestStr = GlobalConstants.apiUrl + "/goal/upsertwithtripid?token="+token
                
                print (requestStr)
                
                let myUrl = URL(string: requestStr)
                
                var request = URLRequest(url:myUrl!)
                
                request.httpMethod = "POST"
                request.addValue ("application/json", forHTTPHeaderField: "content-type")
                var newGoalJSON:JSON = [:]
                newGoalJSON["name"] = JSON(goal.name)
                newGoalJSON["isDone"] = JSON(goal.isDone)
                newGoalJSON["tripId"] = JSON(tripId)
                newGoalJSON["description"] = JSON(goal.description)
                
                print (newGoalJSON)
                
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
                
            // hz
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
                    
                    if !( receivedJson["id"].exists() ) {
                        errorFlag = true
                    }
                    
                    group.leave()
                })
                
                task.resume()
                
                group.notify(queue: .main) {
                    // leaving current view controller
                    if !errorFlag {
                        
                        self.delegate!.refresh()
                        
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // add message here
                        print ("error occured and unable to addPlace. nothing done")
                    }
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

