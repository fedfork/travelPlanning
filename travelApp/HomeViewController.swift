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

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var MainView: UIView!
    
    var tripCounterBefore = 0
    var tripCounterAfter = 0 {
        willSet {
            if tripCounterBefore == newValue{
                showTrips()
            }
        }
    }
    
    var trips : [Trip]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTrips()
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
            
    func getTrips (){
        
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
                guard let token = tok else {
                    print ("ubable to read from the keychain")
                    self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                    return
                }
                
                //created url with token
                let myUrl = URL(string: GlobalConstants.apiUrl + "/trip/getall?token="+token)

                        var request = URLRequest(url:myUrl!)
                
                        request.httpMethod = "GET"
                        request.addValue ("application/json", forHTTPHeaderField: "content-type")
                        
                    

                        //performing request to get trips
                        let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in

        //                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)

                            if error != nil || data == nil {
                                self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                                return
                            }

                            

                                //printing obtained string: for debugging
                                let dataStr = String(bytes: data!, encoding: .utf8)
                                print ("received data=\(dataStr!)")
                                
                                
        //                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as
                                
                                let tripIds = try? JSONDecoder().decode([String].self, from: data!)
                                
                                guard let tripIdentifiers = tripIds
                                    else {
                                        print ("unable to parse trip identifiers")
                                        return
                                }
                                
                                //tripcountersset
                            
                            self.tripCounterBefore = tripIdentifiers.count
                            self.tripCounterAfter = 0
                            
                            //retrieving trips by their identifiers
                                for tripId in tripIdentifiers {
                                    
                                    let myUrl1 = URL(string: GlobalConstants.apiUrl + "/trip/read?id=" + tripId + "&token=" + token)
                                    print ("url for trip read request = " + GlobalConstants.apiUrl + "/trip/read?id=" + tripId + "&token=" + token)
                                    
                                    var tripReadRequest = URLRequest(url: myUrl1! )
                                    tripReadRequest.httpMethod = "GET"
                                    tripReadRequest.addValue ("application/json", forHTTPHeaderField: "content-type")
                                    
                                    let task2 = URLSession.shared.dataTask (with: tripReadRequest, completionHandler: { data2, response, error in
                                        
                                        if error != nil || data == nil {
                                            print ("unable to retrieve trip " + tripId)
                                            return
                                        }
                                        
                                        let tripJs = try? JSONSerialization.jsonObject(with: data2!, options: .mutableContainers) as? NSDictionary
                                        
                                        guard let tripJson = tripJs else { print ("unable to parse trip's json of trip " + tripId); return}
                                        
                                        print (tripJson)
                                        
                                        let trip = Trip(Id: tripJson["id"] as! String, Name: tripJson["name"] as! String, TextField: tripJson["textField"] as! String)
                                        if self.trips == nil {
                                            self.trips = [Trip]()
                                        }
                                        self.trips!.append (trip)
                                        self.tripCounterAfter += 1
                                        
                                    })
                                    task2.resume()
                                }
                            })
                                
                task.resume()
    }

    
    func showTrips (){
        DispatchQueue.main.sync {
            guard let tripList = trips else {print ("showtrips: trip list is empty"); return}
            
            for trip in tripList {
                var tripView = TripView()
                //adding shadow
                tripView.layer.shadowColor = UIColor.black.cgColor
                tripView.layer.shadowOpacity = 1
                tripView.layer.shadowOffset = .zero
                tripView.layer.shadowRadius = 10
                tripView.layer.shadowPath = UIBezierPath(rect: tripView.bounds).cgPath
                
                
                
                tripView.tripName.text? = trip.Name
                tripView.Description.text? = trip.TextField
               
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

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}