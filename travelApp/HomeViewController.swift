//
//  HomeViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 09.02.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var MainView: UIView!
   
    @IBAction func addButtonPressed(_ sender: Any) {
        let addTripViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddTripVC")
        addTripViewController.modalPresentationStyle = .fullScreen
        
        self.present(addTripViewController, animated: true, completion: nil)
    }
    
    var tripCounterBefore = 0
    var tripCounterAfter = 0 {
        willSet {
            if tripCounterBefore == newValue && newValue > 0{
                showTrips()
            }
        }
    }
    
    var trips : [Trip]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let itemsCount = trips?.count else { return 0 }
        print ("itemsInCell=\(itemsCount)")
        return itemsCount
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCollectionViewCell", for: indexPath as! IndexPath) as! TripCollectionViewCell
        
        cell.initiateZeroes()
        
        // initialise cell with data from trips
        guard let trip = trips?[indexPath.item] else { return cell}
        cell.update(for: trip)
        
//        cell.contentView.layer.cornerRadius = 2.0
//        cell.contentView.layer.borderWidth = 1.0
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true;

        
        
        cell.setupDesign()
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //going to nev VC
        
//        let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navVC")  as! UINavigationController
        
        let tripVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tripVC") as! TripViewController
        tripVC.tripId = trips![indexPath.item].Id
        tripVC.modalPresentationStyle = .fullScreen
        self.present(tripVC, animated: true, completion: nil)
        
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gesture recogniser for collectionview
        
        collectionView.delegate = self
        collectionView.dataSource = self
        getTrips()
        
        // Do any additional setup after loading the view.
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTrips()
        collectionView.reloadData()
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
                    // display message
                    return
                }
        
        //clearing trips list
        
        tripCounterBefore = 0
        tripCounterAfter = 0
        trips = nil
                
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
                
                
//              let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as
                
                let tripIds = try? JSONDecoder().decode([String].self, from: data!)
                
                guard let tripIdentifiers = tripIds
                    else {
                        print ("unable to parse trip identifiers")
                        return
                }
                
            //tripcountersset
            
            self.tripCounterBefore = tripIdentifiers.count
            self.tripCounterAfter = 0
            
            print ("tripIdentifiers")
            print(tripIdentifiers)
            
            self.trips = nil
            
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
                        
//                        let tripJs = try? JSONSerialization.jsonObject(with: data2!, options: .mutableContainers) as? NSDictionary
                        
                        let tripJs = try? JSON(data: data2!)
                        guard let tripJson = tripJs else { print ("unable to parse trip's json of trip " + tripId); return}
                        
                        print (tripJson)
                        
                        //parsing places
                        var placeIds: [String] = []
//                        print ("TYPE= \(type(of: tripJson["placeIds"]))")
                        
//                        let tripIds = try? JSONDecoder().decode([String].self, from: tripJson)
//                        for (num,placeId):(String, JSON) in tripJson["placeIds"] {
//                            guard let placeId = placeId.string else {continue}
//                            placeIds.append(placeId)
//                        }
//
//                        print (placeIds)
                        
                        let trip = Trip(Id: tripJson["id"].string ?? "", Name: tripJson["name"].string ?? "", TextField: tripJson["textField"].string ?? "", PlaceIds: placeIds, goodIds: [String](), timeFrom: tripJson["fromDate"].int64 ?? 0, timeTo: tripJson["toDate"].int64 ?? 0)
                        
                        
                        //Added
//                        trip.getDateStringFromTo()
                        
    
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
            collectionView.reloadData()
        }
    }
    
    
    //needed to set concrete size of cell depending on stackview cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width - 20
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }

        let p = gesture.location(in: self.collectionView)

        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            // get the cell at indexPath (the one you long pressed)
            let cell = self.collectionView.cellForItem(at: indexPath)
            // we got current trip, now display q/alert about deleting
            
            print ("tapped on trip \(trips![indexPath.item].Name)")
            
            let choiceAlert = UIAlertController(title: " Выберите действие", message: "Поездка \(trips![indexPath.item].Name)", preferredStyle: .actionSheet)
            choiceAlert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {action in
                self.deleteTrip(tripId: self.trips![indexPath.item].Id)
            } ) )
            choiceAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: {action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(choiceAlert, animated: true, completion: nil)
            
        } else {
            print("couldn't find index path")
        }
    }
    
    func deleteTrip (tripId: String) {
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
            print ("ubable to read from the keychain")
            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
            return
        }
        
//created url with token
        let myUrl = URL(string: GlobalConstants.apiUrl + "/trip/delete?token="+token+"&id="+tripId)
        print ("URL=\(GlobalConstants.apiUrl + "/trip/delete?token="+token+"&id="+tripId)")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "DELETE"
        request.addValue ("application/json", forHTTPHeaderField: "content-type")
        
        //performing request to get trips
        let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in

//                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)

            if error != nil || data == nil {
                self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                return
            }
            print(data!)
            do {
                let json = try JSON (data: data!)
                print ("deletion JSON: \(json)")
            } catch {
                print ("error=\(error)")
            }
            
//            let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//            guard let json1 = json else { print ("unsuccessfull"); return }
//            print (json1)
//            guard let json = jso else { print ("couldn't parse json from server. nothing done."); return }
            
            
            self.getTrips()
        
        })
        task.resume()
        
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

