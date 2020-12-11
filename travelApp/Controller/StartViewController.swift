//
//  StartViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 08.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftKeychainWrapper

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
        
        //check if token exists - no need to authenticate
        
        if KeychainWrapper.standard.string (forKey: "accessToken") != nil {
            autoLogin()
        }

        
        
        
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
    
    func autoLogin(){
        DispatchQueue.main.async {
            let strbrd = UIStoryboard(name: "Main", bundle: nil)
            let homePage = strbrd.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            
            homePage.needSync = true
            
            UIApplication.shared.windows.first?.rootViewController = homePage
            UIApplication.shared.windows.first?.makeKeyAndVisible()
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
