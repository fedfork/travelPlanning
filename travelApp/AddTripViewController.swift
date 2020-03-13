//
//  AddTripViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 03.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class AddTripViewController: UIViewController {
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPressed(_ sender: Any) {
        if let name = nameField.text, name != "" {
            if !checkPickers() { // if dates are not correct
                return
            }
            createTrip(name: name)
        } else {
            //TODO: display EM - string is empty
            print ("Tripname string is empty")
            return
        }
        
        
    }

    @IBOutlet weak var datePickerFrom: UIDatePicker!
    
    @IBOutlet weak var DatePickerTo: UIDatePicker!
    
    @IBOutlet weak var nameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func createTrip(name: String, date1: Int64, date2: Int64) {
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
            guard let token = tok else {
                print ("ubable to read from the keychain")
//                    self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                return
        }
        
        //created url with token
        let myUrl = URL(string: GlobalConstants.apiUrl + "/trip/upsert?token="+token)

        var request = URLRequest(url:myUrl!)
        
        var newTripJson:JSON = [:]
        
        newTripJson["Name"] = JSON(name)
        
        
        
        
        //newTripJson["FromDate"] = JSON("123532332")
        //newTripJson["ToDate"] = JSON("123538332")
        
        print ("newTRipJson = ")
        print (newTripJson)
        
        request.httpMethod = "POST"
        request.addValue ("application/json", forHTTPHeaderField: "content-type")
        
        do {
            request.httpBody = try newTripJson.rawData()
        } catch {
            print ("Error \(error). No request performed, terminating")
            return
        }
        
        //performing request to get trips
        let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in
            if error != nil || data == nil {
                if let error = error {
                    print ("Request ended up with error \(error)")
                } else {
                    print ("data of request is nil")
                }
                return
            }
            let recievedJSON = JSON(data!)
            print (recievedJSON)
            
            self.dismissVC()
        })
        task.resume()
        
        return
    }
    
    func dismissVC(){
        DispatchQueue.main.sync {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkPickers () -> Bool {
        if DatePickerTo.date < datePickerFrom.date {
            print ("checkPickers()::trip ends before it starts")
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
