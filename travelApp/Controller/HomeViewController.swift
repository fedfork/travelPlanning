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
import CoreData

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RefreshableDelegate {

    
    var hamburgerMenuIsVisible = false
    
    @IBAction func hamburgerButtonPressed(_ sender: Any) {
        if !hamburgerMenuIsVisible {
            tripViewLeading.constant = 120
            tripViewTrailing.constant = -120
            hamburgerMenuIsVisible = true
        } else {
            tripViewLeading.constant = 0
            tripViewTrailing.constant = 0
            hamburgerMenuIsVisible = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) {(animationComplete) in
            print ("animation is complete")
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logout()
    }
    @IBOutlet var tripView: UIView!
    
    @IBOutlet var tripViewLeading: NSLayoutConstraint!
    
    @IBOutlet var tripViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var MainView: UIView!
   
    @IBAction func addButtonPressed(_ sender: Any) {
        let addTripViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddTripVC")
        addTripViewController.modalPresentationStyle = .fullScreen
        
        self.present(addTripViewController, animated: true, completion: nil)
    }
    
    
    var needSync = true //parent VC may change this
    
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
        tripVC.tripId = trips![indexPath.item].id
        tripVC.modalPresentationStyle = .fullScreen
        self.present(tripVC, animated: true, completion: nil)
        
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gesture recogniser for collectionview
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //get trips from core data
        
        // Do any additional setup after loading the view.
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
        let api = API()
        
        Category.saveCategoriesFromJson( json: api.getCategories() )
        
        //let sc = StorageCoordinator()
        //sc.synchroniseWithServer()
        
        //тест - кладем в кордату трип, помеченный измененным; получаем его с помощью фетчреквеста, печатаем
        /*
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            print ("no delegate")
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        guard let tripEntity = NSEntityDescription.entity(forEntityName:"Trip", in: managedContext) else {print("bad trip entity"); return}
        guard let goodEntity = NSEntityDescription.entity(forEntityName:"Good", in: managedContext) else {print("bad trip entity"); return}
        guard let goalEntity = NSEntityDescription.entity(forEntityName:"Goal", in: managedContext) else {print("bad trip entity"); return}
        guard let purchaseEntity = NSEntityDescription.entity(forEntityName:"Purchase", in: managedContext) else { print("bad trip entity"); return }
        guard let placeEntity = NSEntityDescription.entity(forEntityName:"Place", in: managedContext) else { print("bad trip entity"); return }
        //кладем в кор дату
        let trip = Trip(entity:tripEntity, insertInto: managedContext)
        trip.name = "BAD trip"
        trip.textField = "very BAD trip"
        trip.wasChanged = true
        
        let date = Date()
        
        
        trip.dateFrom = date
        trip.dateTo = date
//        let trip2 = Trip(entity:tripEntity, insertInto: managedContext)
//        trip2.name = "GOOD trip"
//        trip2.textField = "very GOOD trip"
//        trip2.wasChanged = false
//        do {
//            try managedContext.save()
//        } catch let error {
//            print (error.localizedDescription)
//            return
//        }
//        guard let changedTrips = Trip.fetchAllChangedTrips() else {print ("did not get trips"); return }
//
//        print ("changed trips:")
//        print (changedTrips)
//
//        let purchase = Purchase (entity:purchaseEntity, insertInto: managedContext)
//        purchase.name = "purch1"
//        purchase.wasChanged = true
//        guard let changedPurchases = Purchase.fetchAllChangedPurchases() else {print ("did not get trips"); return }
//        print ("changed purchases:")
//        print (changedPurchases)
//
//
//
//        let good = Good (entity:goodEntity, insertInto: managedContext)
//        good.name = "good1"
//        good.wasChanged = true
//        guard let changedGoods = Good.fetchAllChangedGoods() else {print ("did not get goods"); return }
//        print ("changed purchases:")
//        print (changedGoods)

        let place = Place (entity:placeEntity, insertInto: managedContext)
        place.id = "hzhzhzhz"
        place.name = "place1"
        place.wasChanged = true
        guard let changedPlaces = Place.fetchAllChangedPlaces() else {print ("did not get places"); return }
        print ("changed place:")
        print (changedPlaces)
        
        let place2 = Place (entity:placeEntity, insertInto: managedContext)
        place2.id = "sukasuk"
        place2.name = "place1"
        place2.wasChanged = true
     
        
        // конец теста
        
        //добавим к трипу место и сделаем из этого JSON
        var placesArray: [Place] = []
        placesArray.append(place)
        placesArray.append(place2)
        trip.triptoplace = NSSet(array: placesArray)
        
        print ("TRIP serialized to JSON:")
        print ("TRIP serialized to JSON: \(trip.serializeToJSON())")
        */
        
        
    
        
        
    
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // syncinc if needed
        
        if needSync {
            let strbrd = UIStoryboard(name: "Main", bundle: nil)
            let syncVC = strbrd.instantiateViewController(identifier: "SyncVC") as! SyncViewController

            //syncVC.modalPresentationStyle = .popover
            syncVC.delegate = self
            self.present(syncVC, animated: true, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
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
            
    
    func showTrips (){
        DispatchQueue.main.sync {
            collectionView.reloadData()
        }
    }
    
    
    //needed to set concrete size of cell depending on stackview cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width - 20
        let yourHeight = CGFloat(200.0)
        
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
            
            print ("tapped on trip \(trips![indexPath.item].name)")
            
            let choiceAlert = UIAlertController(title: " Выберите действие", message: "Поездка \(trips![indexPath.item].name)", preferredStyle: .actionSheet)
            choiceAlert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {action in
                self.deleteTrip(tripId: self.trips![indexPath.item].id!)
            } ) )
            choiceAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: {action in
                
            }))
            self.present(choiceAlert, animated: true, completion: nil)
            
        } else {
            print("couldn't find index path")
        }
    }
    
    func deleteTrip (tripId: String) {
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func logout () {
        //clear deleted entities list
        DeletedObjectList.clearDeletedEntitiesLists()
        LastSyncTimeHelper.clearLastSyncTime()
        
        if !KeychainWrapper.standard.removeObject(forKey: "accessToken") {
            print ("unable to delete token from keychain")
            return
        }
        
        //clearing core data
        let sc = StorageCoordinator()
        sc.clearStorage()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let startVC = storyboard.instantiateViewController(identifier: "startVC")
        
        UIApplication.shared.windows.first?.rootViewController = startVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func refresh () {
        //let dig core data trips and put them in Trips
        trips = Trip.fetchAllTrips(changed: false)
        collectionView.reloadData()
    }
}

protocol RefreshableDelegate{
    func refresh()
}
