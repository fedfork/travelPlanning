//
//  SignInViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 02.02.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        let userName = userNameField.text
        let password = passwordField.text
        
        if (userName?.isEmpty)! || (password?.isEmpty)! {
            print ("SignIn: One of the fields is missing")
            displayMessage (title: "Ошибка", message: "Одно из требуемых полей отсутствует")
            return
        }
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        let myUrl = URL(string: "https://api.fake.rest/cfe9600d-bc5c-4945-aa30-f7387b71706e/authenticate")
        
        var request = URLRequest(url:myUrl!)
        
        
        request.httpMethod = "POST"
//        request.addValue ("application/json", forHTTPHeaderField: "content-type")
//        request.addValue ("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["userName": userName!, "userPassword": password!] as [String: String]
        
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
            
            
        } catch let error {
            
            print(error.localizedDescription)
            displayMessage(title: "Ошибка", message: "Не удалось сериализовать")
            
            return
        }
        
        
        
        let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil || data == nil {
                self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJson = json {
                    
                    let accessToken = parseJson["token"] as? String
                    let userId = parseJson["id"] as? String
                    guard let token = accessToken, let id = userId else {
                        print ("token is bad")
                        self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                        return
                    }
                    
                    if !KeychainWrapper.standard.set(token, forKey: "accessToken") ||
                        !KeychainWrapper.standard.set(id, forKey: "userId") {
                        print ("ubable to write to the keychain")
                        self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        let strbrd = UIStoryboard(name: "Main", bundle: nil)
                        let homePage = strbrd.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                        
                      
                        UIApplication.shared.windows.first?.rootViewController = homePage
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                        
                        
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        appDelegate.window!.rootViewController =  homePage
//
//
                        
//                        self.showDetailViewController(homePage, sender: self)
//                      self.present(homePage, animated: true, completion: nil)
                        
                    }
                    
                    
                    
                    print ("Access token : \(token) \(id)")
                    
                    
                } else {
                    self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                }
                
            } catch {
                
                print ("Not able to serialize token")
                self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                
            }
            
        })
        
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func displayMessage (title: String, message: String){
        DispatchQueue.main.async {
        
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            self.present (alert, animated: true, completion: nil)
            
//            alert.addAction(UIAlertAction(title: "ShowAndDismiss", style: .cancel, handler: {
//
//            }))
            let timer2 = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                alert.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func removeActivityIndicator (activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
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
