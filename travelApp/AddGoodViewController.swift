//
//  AddGoodViewController.swift
//  
//
//  Created by Fedor Korshikov on 21.03.2020.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class AddGoodViewController: UIViewController {
    
    var delegate: refreshableDelegate?
    var good: Good?
    var tripId: String?
    
    @IBAction func backButton(_ sender: Any) {
        delegate?.refresh()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        addGoodAndLeave()
    }
    
    @IBOutlet var nameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func addGoodAndLeave() {
            
        var good = Good(name: nameLabel.text ?? "", description: "", id: "", isTaken: false)
                
                
            
            guard let tripId = tripId else { print ("bad trip"); return }
            
            let tok = KeychainWrapper.standard.string(forKey: "accessToken")
            guard let token = tok else {
                print ("ubable to read from the keychain")
    //            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                return
            }
            
            
            var requestStr = GlobalConstants.apiUrl + "/good/upsertwithtripid?token="+token
            
            print (requestStr)
            
            let myUrl = URL(string: requestStr)
            
            var request = URLRequest(url:myUrl!)
            
            request.httpMethod = "POST"
            request.addValue ("application/json", forHTTPHeaderField: "content-type")
            var newPlaceJson:JSON = [:]
            newPlaceJson["name"] = JSON(good.name)
            newPlaceJson["isTook"] = JSON(good.isTaken)
            newPlaceJson["tripId"] = JSON(tripId)
            newPlaceJson["description"] = JSON(good.description)
            
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
