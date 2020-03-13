//
//  TripViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 05.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class TripViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    var trip: Trip?
    
    var places: [Place]?{
        didSet {
            if let pl = places, pl.count>0{
                showCvData()
            }
        }
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tripName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (trip?.Id)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadPlaces()
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let itemsCount = places?.count else {return 0}
        
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath as IndexPath) as! PlaceCollectionViewCell
        
        guard let place = places?[indexPath.item] else { return cell }
        
        cell.update(for: place)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartHeaderCollectionReusableView", for: indexPath)
            // Customize headerView here
            return headerView
        }
        fatalError()
    }
    
    
    func loadPlaces () {
        let tok = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let token = tok else {
            print ("ubable to read from the keychain")
//            self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
            return
        }
        
        guard let currentTrip = trip else {print("no trip"); return}
            
        places = [Place]()
        
        for placeId in currentTrip.PlaceIds
        {
            //created url with token
            let myUrl = URL(string: GlobalConstants.apiUrl + "/place/read?token="+token+"&id="+placeId)

            var request = URLRequest(url:myUrl!)

            request.httpMethod = "GET"
            request.addValue ("application/json", forHTTPHeaderField: "content-type")
            
            //performing request to get place
            let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in

    //                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)

                if error != nil || data == nil {
    //                self.displayMessage(title: "Ошибка", message: "От сервера получен некорректный ответ")
                    return
                }

                

                    //printing obtained string: for debugging
                    let dataStr = String(bytes: data!, encoding: .utf8)
                    print ("received data=\(dataStr!)")
                    
                    
    //                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as
                    
                    let place = try? JSON(data: data!)
                    
                    guard let placeJSON = place
                        else {
                            print ("unable to parse trip identifiers")
                            return
                    }
                var newPlace = Place(name: placeJSON["name"].string ?? "", adress: placeJSON["adress"].string ?? "", Description: placeJSON["description"].string ?? "", id: placeJSON["id"].string ?? "")
                
                
                self.places!.append (newPlace)
                self.showCvData()
            })
            task.resume()
    }
}

    func showCvData (){
        DispatchQueue.main.sync {
            collectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width - 20
        let yourHeight = yourWidth/3 

        return CGSize(width: yourWidth, height: yourHeight)
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
