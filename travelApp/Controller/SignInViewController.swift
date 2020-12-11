//
//  SignInViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 02.02.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON


class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let strb = UIStoryboard(name: "Main", bundle: nil)
        let regVC = strb.instantiateViewController(withIdentifier: "regVC")
        
        UIApplication.shared.windows.first?.rootViewController = regVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        var userName = userNameField.text
        var password = passwordField.text
        
        if (userName?.isEmpty)! || (password?.isEmpty)! {
            print ("SignIn: One of the fields is missing")
            displayMessage (vc:self, title: "Ошибка", message: "Одно из требуемых полей отсутствует")
            return
        }
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        let myUrl = URL(string: Global.apiUrl + "/auth/login")

        var request = URLRequest(url:myUrl!)


        request.httpMethod = "POST"
        request.addValue ("application/json", forHTTPHeaderField: "content-type")
//      request.addValue ("application/json", forHTTPHeaderField: "Accept")

        //данные темы
        
//        userName = "why1799@gmail.com"
//        password = "12345"
//
        let postString = ["Email": userName!, "Password": password!] as [String: String]

        do {

            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)


        } catch let error {

            print(error.localizedDescription)
            displayMessage(vc: self, title: "Ошибка", message: "Не удалось сериализовать")

            return
        }



        let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in

            self.removeActivityIndicator(activityIndicator: myActivityIndicator)

            if error != nil || data == nil {
                displayMessage(vc: self, title: "Ошибка", message: "От сервера получен некорректный ответ")
                return
            }

            do {
                let json = try? JSON(data: data!)
                print ("строка: \(json)")
                

                if let parseJson = json {

                    print (parseJson)

                    let token = parseJson["token"].stringValue
                    let id = parseJson["userId"].stringValue
                    
                    
                    

                    if !KeychainWrapper.standard.set(token, forKey: "accessToken") ||
                        
                        !KeychainWrapper.standard.set(id, forKey: "userId") {
                        print ("ubable to write to the keychain")
                        
                        displayMessage(vc: self, title: "Ошибка", message: "От сервера получен некорректный ответ")
                        return
                    }

                    
                    
                    DispatchQueue.main.async {

                        let strbrd = UIStoryboard(name: "Main", bundle: nil)
                        let homePage = strbrd.instantiateViewController(identifier: "HomeViewController") as! HomeViewController

                        //preparing to clear login scenario
                        LastSyncTimeHelper.clearLastSyncTime()
                        DeletedObjectList.clearDeletedEntitiesLists()
                        homePage.needSync = true
                        
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
        
//
//        let strbrd = UIStoryboard(name: "Main", bundle: nil)
//        let homePage = strbrd.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
//
//        UIApplication.shared.windows.first?.rootViewController = homePage
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
//
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
//    func displayMessage (title: String, message: String){
//        DispatchQueue.main.async {
//
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//            self.present (alert, animated: true, completion: nil)
//
////            alert.addAction(UIAlertAction(title: "ShowAndDismiss", style: .cancel, handler: {
////
////            }))
//            let timer2 = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
//                alert.dismiss(animated: true, completion: nil)
//            }
//
//        }
//    }
    
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
