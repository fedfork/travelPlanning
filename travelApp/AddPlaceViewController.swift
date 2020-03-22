//
//  AddPlaceViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 16.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation
import SwiftKeychainWrapper

class AddPlaceViewController: UIViewController, UITextViewDelegate {
    
    enum PlaceControllerStates {
        case add
        case edit
        case show
    }
    
    var delegate: refreshableDelegate?
    var place: Place?
    var tripId: String?
    
    var state = PlaceControllerStates.add
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var adressField: UITextField!
    @IBOutlet var descTextView: UITextView!
    @IBOutlet var backCancelButton: UIButton!    
    @IBOutlet var editSaveButton: UIButton!
    
    
    @IBAction func backCancelButtonClicked(_ sender: Any) {
        
        switch state {
            case .add:
                cancelAdding()
            case .edit:
                cancelEditing()
            case .show:
                cancelShowing()
        }
        
    }
    
    
    @IBAction func editSaveButtonClicked(_ sender: Any) {
        
        switch state {
            case .add:
                addPlaceAndLeave()
            case .edit:
                
                savePlaceAndChangeMode()
            case .show:
                
                startEditingPlace()
                
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descTextView.delegate = self
        switch state {
            case .add:
                initiateToAdd()
            case .edit:
                initiateToEdit()
            case .show:
                initiateToShow()
        }
        
    }
    
    func initiateToShow() {
        // editing header
        backCancelButton.setTitle ( "Назад", for: .normal )
        editSaveButton.setTitle ( "Править", for: .normal )
        headerLabel.text = ""
        
        // loading text fields from place
        guard let place = place else {return}
        nameField.text = place.name
        adressField.text = place.adress
        descTextView.text = place.description
        nameField.isEnabled = false
        adressField.isEnabled = false
        descTextView.isEditable = false
    }
    
    func initiateToAdd() {
        // editing header
        backCancelButton.setTitle("Отмена", for: .normal)
        editSaveButton.setTitle("Сохранить", for: .normal)
        headerLabel.text = "Добавление места"
        
        // loading text fields from place
        
        nameField.text = ""
        adressField.text = ""
        
        descTextView.text = "Описание..."
        descTextView.textColor = UIColor.lightGray
        
        nameField.isEnabled = true
        adressField.isEnabled = true
        descTextView.isEditable = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Описание..."{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Описание..."
            textView.textColor = UIColor.gray
        }
    }
    func initiateToEdit() {
        
        // editing header
        backCancelButton.setTitle("Отмена", for: .normal)
        editSaveButton.setTitle("Сохранить", for: .normal)
        headerLabel.text = "Изменение места"
        
        // loading text fields from place
        guard let place = place else {return}
        nameField.text = place.name
        adressField.text = place.adress
        descTextView.text = place.description
        nameField.isEnabled = true
        adressField.isEnabled = true
        descTextView.isEditable = true
    }
    
    func cancelAdding () {
        delegate?.refresh()
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelEditing() {
        state = .show
        initiateToShow()
    }
    
    func cancelShowing() {
        delegate?.refresh()
        self.dismiss(animated: true, completion: nil)
    }
    
    func addPlaceAndLeave() {
        if !verifyFields() {
            return
        }
        
        var place = Place(name: nameField.text ?? "", adress: adressField.text ?? "", Description: descTextView.text ?? "", id: "", checked: false, userId: "")
        
        guard let tripId = tripId else { print ("bad trip"); return }
        
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
            print ("ubable to read from the keychain")
//            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
            return
        }
        
        
        var requestStr = GlobalConstants.apiUrl + "/place/upsertwithtripid?token="+token
        
        print (requestStr)
        
        let myUrl = URL(string: requestStr)
//        print (myUrl)
        
        
        
        var request = URLRequest(url:myUrl!)
        
        
        request.httpMethod = "POST"
        request.addValue ("application/json", forHTTPHeaderField: "content-type")
        var newPlaceJson:JSON = [:]
        newPlaceJson["name"] = JSON(place.name)
        newPlaceJson["adress"] = JSON(place.adress)
        newPlaceJson["isVisited"] = JSON(place.checked)
       // newPlaceJson["userId"] = JSON(place.userId)
        newPlaceJson["tripId"] = JSON(tripId)
        newPlaceJson["description"] = JSON(place.description)
        
        
        print (newPlaceJson)
        
        do {
           request.httpBody = try newPlaceJson.rawData()
       } catch {
           print ("Error \(error). No request performed, terminating")
           return
       }
        
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
    
    //edits place and then changes mode from edit to show
    func savePlaceAndChangeMode()  {
        guard let place = place else { print ("place is missing"); return  }
        
        var newPlace = Place(name: nameField.text ?? "", adress: adressField.text ?? "", Description: descTextView.text ?? "", id: place.id, checked: place.checked, userId: place.userId)
        
//        guard let trip = trip else { print ("bad trip"); return }
                
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
            print ("ubable to read from the keychain")
//            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
            return
        }
        
        let myUrl = URL(string: GlobalConstants.apiUrl + "/place/upsert?token="+token)

        var request = URLRequest(url:myUrl!)
        
        
        
        request.httpMethod = "POST"
        request.addValue ("application/json", forHTTPHeaderField: "content-type")
        var newPlaceJson:JSON = [:]
        newPlaceJson["id"] = JSON(newPlace.id)
        newPlaceJson["name"] = JSON(newPlace.name)
        newPlaceJson["adress"] = JSON(newPlace.adress)
        newPlaceJson["isVisited"] = JSON(newPlace.checked)
        newPlaceJson["userId"] = JSON(newPlace.userId)
        newPlaceJson["description"] = JSON(newPlace.description)
        
        
//      newPlaceJson["tripId"] = JSON(trip.Id)
        

        do {
           request.httpBody = try newPlaceJson.rawData()
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
                
                self.place = newPlace
                self.initiateToShow()
                self.state = .show
            } else {
                print ("unable to save trip")
                return
            }
        }
        
        
    }
    
    func startEditingPlace(){
        
        initiateToEdit()
        
        state = .edit
    }
    
    func verifyFields() -> Bool {
        if let isEmpty = nameField.text?.isEmpty, isEmpty {
            print ("field with name is empty")
            return false
        }
        return true
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
