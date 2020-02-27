//
//  HomeViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 09.02.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class HomeViewController: UIViewController {

    @IBOutlet weak var StackView: UIStackView!
    
    @IBOutlet var MainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tripView = TripView()//TripView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
//
//        tripView.isHidden = false
//        MainView.addSubview(tripView)
        
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
            print ("ubable to read from the keychain")
            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
            return
        }
        
        let myUrl = URL(string: GlobalConstants.apiUrl + "/trip/getall?token="+token)
        
            

                var request = URLRequest(url:myUrl!)

                print ("myURL=\(myUrl!)")
        
                request.httpMethod = "GET"
                request.addValue ("application/json", forHTTPHeaderField: "content-type")
        //      request.addValue ("application/json", forHTTPHeaderField: "Accept")
                
            


                let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in

//                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)

                    if error != nil || data == nil {
                        self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                        return
                    }

                    do {

                        let dataStr = String(bytes: data!, encoding: .utf8)
                        print ("received data=\(dataStr!)")
                        
                        
//                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as
                        do {
                            let tripMod = try JSONDecoder().decode([String].self, from: data!)
                            print (tripMod)
                            
                        } catch {
                            print (error)
                        }
                        
                        
                        if false {

//                            print (tripModel)
                            
                            
//
//                            let accessToken = parseJson["token"] as? String
//                            let userId = parseJson["userId"] as? String
//                            guard let token = accessToken, let id = userId else {
//                                print ("token is bad")
//                                self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
//                                return
//                            }
//
//                            if !KeychainWrapper.standard.set(token, forKey: "accessToken") ||
//                                !KeychainWrapper.standard.set(id, forKey: "userId") {
//                                print ("ubable to write to the keychain")
//                                self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
//                                return
//                            }
//
//                            DispatchQueue.main.async {
//
//                                let strbrd = UIStoryboard(name: "Main", bundle: nil)
//                                let homePage = strbrd.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
//
//
//                                print ("Access token : \(token) \(id)")
//
//                                UIApplication.shared.windows.first?.rootViewController = homePage
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//
//
//


//                            }






                        } else {
                            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                        }

                    } catch {

                        print ("Not able to serialize token")
                        self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")

                    }
                })
        
        
        task.resume()
        StackView.addArrangedSubview(TripView())
        
        
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
            
    struct TripsModel: Decodable {
        let tripArray: [String]

        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            tripArray = try container.decode([String].self)
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
