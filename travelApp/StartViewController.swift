//
//  StartViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 08.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftyJSON

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make buttons round
        registerButton.layer.cornerRadius = 10
        registerButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        
//        var json = JSON()
//        json["name"] = JSON ("fedor")
//        json["surname"] = JSON("korshikov")
//        UserDefaultsHelper.addDeletedEntity (ofType: "Place", entity:json)
//
//        var json2 = JSON()
//        json2["mama"] = JSON("katya")
//        UserDefaultsHelper.addDeletedEntity (ofType: "Place", entity:json2)
//
//        print (UserDefaultsHelper.getDeletedEntitiesList(ofType: "Place"))
//
//
        let jsonString = """
        {
          "updated" : {
            "places" : [
            {
              "description" : "blah blah blah hahahaha",
              "name" : "Good Place",
              "date" : 637261344000000000,
              "id" : "fa7822de-b294-4949-b19a-d636ab2ad3be",
              "lastUpdate" : 637269398768254580,
              "photoIds" : [
                "58d79aa8-c48f-4982-a550-1a1f36510e36"
              ],
              "adress" : "Bolshaya Per street home 6 k 2",
              "userId" : "57cccd13-8ac6-402c-acde-dba6b07d820b",
              "isVisited" : false
            },
            ]
          },
          "deleted" : {
            
        }
        }
        """
       
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            Place.syncPlaces(syncInputJson: json!)
        }
        
        guard let places = Place.fetchAllPlaces(changed: false) else {return }
        print (places)
        places[0].wasChanged = false
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        appDelegate.saveContext()
        
        let jsonString2 = """
        {
          "updated" : {
            "places" : [
            {
              "description" : "blah blah blah hahahaha",
              "name" : "Baaad Place",
              "date" : 637261344000000000,
              "id" : "fa7822de-b294-4949-b19a-d636ab2ad3be",
              "lastUpdate" : 637269398768254580,
              "photoIds" : [
                "58d79aa8-c48f-4982-a550-1a1f36510e36"
              ],
              "adress" : "Bolshaya Per street home 6 k 2",
              "userId" : "57cccd13-8ac6-402c-acde-dba6b07d820b",
              "isVisited" : false
            },
            ]
          },
          "deleted" : {
            
        }
        }
        """
        
        if let dataFromString = jsonString2.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            Place.syncPlaces(syncInputJson: json!)
        }
        
        guard let places2 = Place.fetchAllPlaces(changed: false) else {return }
        print (places2)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let strb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = strb.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        UIApplication.shared.windows.first?.rootViewController = loginVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let strb = UIStoryboard(name: "Main", bundle: nil)
        let regVC = strb.instantiateViewController(withIdentifier: "regVC") as! registerViewController
        
        UIApplication.shared.windows.first?.rootViewController = regVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
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
