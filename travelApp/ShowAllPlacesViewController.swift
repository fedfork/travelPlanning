//
//  ShowAllPlacesViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 15.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class ShowAllPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, refreshableDelegate {
    
    
    
    var tripId: String?
    
    var trip: Trip? {
        didSet
        {

            if trip?.triptoplace?.allObjects is [Place]{
                print ("yes it is")
            }
            places = trip?.triptoplace?.allObjects as? [Place] ?? [Place]()
            
            print("массив мест: \(places)")
        }
    }
    
    var places: [Place] = [Place]()

    @IBOutlet var tableView: UITableView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadPlaces()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presentPlaceVC(inMode: .add, place: nil)
    }
    

    // configure tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
        if indexPath.item >= places.count { cell.setValues(name: "", address: ""); return cell }
        let place = places[indexPath.item]
        cell.setValues(name: place.name!, address: place.adress!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // instantiate and present places view controller in show mode
        if indexPath.item >= places.count {
            print ("no such place")
            return
        }
        let place = places[indexPath.item]
        presentPlaceVC(inMode: .show, place: place)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
//                tableView.deleteRows(at: [indexPath], with: .fade)
         }
        
        
    }
    
    // finished configuring table view
    
    

    func reloadTableViewData() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    func presentPlaceVC (inMode: AddPlaceViewController.PlaceControllerStates, place: Place?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let placeVC = storyboard.instantiateViewController(identifier: "placeVC") as! AddPlaceViewController
        
        placeVC.state = inMode
        
        if inMode != .add {
            placeVC.place = place
        } else {
            placeVC.tripId = tripId
        }
        
        placeVC.delegate = self
        
        self.present(placeVC, animated: true, completion: nil)
    }
    
    
    
     
    
    func deletePlace (withId: String, positionInTable: IndexPath) {
         
    }
    
    func refresh() {

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

protocol refreshableDelegate {
    func refresh()
}
