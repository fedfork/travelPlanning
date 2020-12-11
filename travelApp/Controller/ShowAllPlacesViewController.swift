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

class ShowAllPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShowAllPlacesViewControllerDelegate {
    
    var places: [Place] = [Place]()
    
    @IBAction func mapButtonPressed(_ sender: Any) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let placesMapVC = storyboard.instantiateViewController(identifier: "PlacesOnMapViewController") as! PlacesOnMapViewController
        placesMapVC.annotations = GooglePlacesAPIManager.geocodeBatchOfAddresses(places: places)
         
         self.present(placesMapVC, animated: true, completion: nil)
    }
    
    func tickObject(atIndexPath indexPath: IndexPath) {
        //change place's checked status
        checkUncheckPlace(place: places[indexPath.item])
        sortPlaces()
        tableView.reloadData()
    }
    
    func checkUncheckPlace(place: Place){
        
        Place.editPlace(place: place, adress: place.adress!, checked: !place.checked, date: place.date!, description: place.descript!, name: place.name!, phone: place.phone)
        
    }
    
    func sortPlaces() {
        places.sort(by: { if $0.checked != $1.checked {
            return !$0.checked && $1.checked
        } else {
            return $0.date! < $1.date!
            }
        })
    }
    
    var trip: Trip? {
        didSet
        {
           
        }
    }
    
    

    @IBOutlet var tableView: UITableView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        places = trip?.triptoplace?.allObjects as? [Place] ?? [Place]()
        sortPlaces()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadPlaces()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presentAddPlaceVC()
    }
    

    // configure tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
        if indexPath.item >= places.count { cell.setValues(name: "", address: "", imageLight: UIImage(named: "notPressedRb")!, imageDark: UIImage(named: "rbPressedYellow")!, imageIsLight: true, indexPath: indexPath); return cell }
        let place = places[indexPath.item]
        cell.setValues(name: place.name!, address: place.adress!, imageLight: UIImage(named: "pressedRbYellow"), imageDark: UIImage(named: "notPressedRb"), imageIsLight: place.checked, indexPath: indexPath)
        cell.delegate = self
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
        presentShowPlaceVC(place: place)
        //presentPlaceVC(inMode: .show, place: place)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            
            if indexPath.item >= places.count {return}
            let place = places[indexPath.item]
        
            if ( Place.deletePlace(place: places[indexPath.item]) ) {
                places.remove(at: indexPath.item)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
         }
    }
    
    // finished configuring table view
    
    

    
    
    func presentShowPlaceVC(place: Place){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        "ShowPlaceVCС"
        let placeVC = storyboard.instantiateViewController(identifier: "ShowPlaceVCС") as! ShowPlaceViewController
        placeVC.trip = trip
        placeVC.place = place
        placeVC.delegate = self
        self.present(placeVC, animated: true, completion: nil)
    }
    
    func presentAddPlaceVC (){
        
        // present different VC of navigation controller depending on internet connection state
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(identifier: "NavVC") as! UINavigationController
        let searchPlaceVC = storyboard.instantiateViewController(identifier: "SearchPlaceVC") as! SearchPlaceViewController
        let placeVC = storyboard.instantiateViewController(identifier: "PlaceVCС") as! PlaceViewController
        
        print ("self.trip=\(self.trip)")
        
        searchPlaceVC.trip = self.trip
        placeVC.trip = self.trip
        
        searchPlaceVC.delegate = self
        placeVC.delegate = self
        
        if InternetConnectionManager.isConnectedToNetwork() {
            navVC.setViewControllers([searchPlaceVC, placeVC], animated: false)
            navVC.popToRootViewController(animated: false)
        }else{
            navVC.setViewControllers([placeVC], animated: false)
        }
        
        //navVC.pushViewController(searchPlaceVC, animated: false)
        self.present(navVC, animated: true,  completion: nil)
        
        /*
        let placeVC = storyboard.instantiateViewController(identifier: "placeVC") as! AddPlaceViewController
        
        placeVC.state = inMode
        
        if inMode != .add {
            placeVC.place = place
        } else {
            placeVC.trip = trip
        }
        
        placeVC.delegate = self
        
        self.present(placeVC, animated: true, completion: nil)
        */
    }
    
    
    
     
    
    func refetchData () {
        places = trip?.triptoplace?.allObjects as? [Place] ?? [Place]()
        sortPlaces()
        
        tableView.reloadData()
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

protocol ShowAllPlacesViewControllerDelegate {
    func refetchData()
    func tickObject(atIndexPath indexPath: IndexPath)
}


