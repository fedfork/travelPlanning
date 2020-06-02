//
//  registerViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 08.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class registerViewController: UIViewController {

    
    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
  
    @IBAction func loginButtonPressed(_ sender: Any) {
        let strb = UIStoryboard(name: "Main", bundle: nil)
        let signVC = strb.instantiateViewController(withIdentifier: "SignInViewController")
        
        UIApplication.shared.windows.first?.rootViewController = signVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        var name = nameField.text
        var email = emailField.text
        var password = passwordField.text
        
        if (email?.isEmpty)! || (password?.isEmpty)! || (name?.isEmpty)! {
            print ("SignIn: One of the fields is missing")
            displayMessage (vc: self, title: "Ошибка", message: "Одно из требуемых полей отсутствует")
            return
        }
        
        let myUrl = URL(string: Global.apiUrl + "/auth/register")

                var request = URLRequest(url:myUrl!)

            
                request.httpMethod = "POST"
                request.addValue ("application/json", forHTTPHeaderField: "content-type")
        //      request.addValue ("application/json", forHTTPHeaderField: "Accept")

                //данные темы
                
        //        userName = "why1799@gmail.com"
        //        password = "12345"
        //
                let postString = ["Email": email!,  "Username":name!, "Password": password!] as [String: String]
                
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)

                } catch let error {

                    print(error.localizedDescription)
                    displayMessage(vc: self, title: "Ошибка", message: "Не удалось сериализовать")

                    return
                }



                let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in


                    if error != nil || data == nil {
                        displayMessage(vc: self, title: "Ошибка", message: "От сервера получен некорректный ответ")
                        return
                    }

                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        
                        if let parseJson = json {
                            
                            print (parseJson)
                            
                            let accessToken = parseJson["token"] as? String
                            let userId = parseJson["userId"] as? String
                            
                            
                            guard let token = accessToken, let id = userId else {
                                print ("token is bad")
                                displayMessage(vc: self, title: "Ошибка", message: "От сервера получен некорректный ответ")
                                return
                            }

                            if !KeychainWrapper.standard.set(token, forKey: "accessToken") ||
                                !KeychainWrapper.standard.set(id, forKey: "userId") {
                                print ("ubable to write to the keychain")
                                displayMessage(vc: self, title: "Ошибка", message: "От сервера получен некорректный ответ")
                                return
                            }
                        
                            DispatchQueue.main.async {

                                let strbrd = UIStoryboard(name: "Main", bundle: nil)
                                let homePage = strbrd.instantiateViewController(identifier: "HomeViewController") as! HomeViewController


                                print ("Access token : \(token) \(id)")

                                UIApplication.shared.windows.first?.rootViewController = homePage
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                            }
                            
                            
                            
                        } else {
                            displayMessage(vc: self, title: "Ошибка", message: "От сервера получен некорректный ответ")
                        }

                    } catch {

                        print ("Not able to serialize token")
                        displayMessage(vc: self, title: "Ошибка", message: "От сервера получен некорректный ответ")

                    }
                    
                })
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 20
        registerButton.clipsToBounds = true

        // Do any additional setup after loading the view.
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
