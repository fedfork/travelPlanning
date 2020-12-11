//
//  ShowPlaceViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 01.11.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import MapKit

class ShowPlaceViewController: UIViewController,  ShowPlaceViewControllerDelegate {
    
    
   
    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate?.refetchData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var name: UITextField!
    @IBOutlet var address: UITextField!
    
    var cellsFactory = PlaceVCCellFactory()
    var delegate: ShowAllPlacesViewControllerDelegate?
    
    func update() {
        updateCells()
    }
    
    var annotation: PlaceMapAnnotation?
    var trip: Trip?
    var place: Place?
    
    //places data fields
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        guard let place = place else {return}
        name.text = place.name
        address.text = place.adress
        initiateCellsFactory()
        
        // Do any additional setup after loading the view.
    }
    
    func initiateCellsFactory(){
        guard let place = self.place else {return}
        cellsFactory.addDetailsCell(name: "Дата" , descript: place.date!.string , imageEmpty: UIImage(named:"calendar"), imageFilled: UIImage(named:"calendarYellow"), mult: 0.48, height: CGFloat(100))  // index 0
        cellsFactory.addDetailsCell(name: "Телефон", descript: place.phone, imageEmpty: UIImage(named:"phone"), imageFilled: UIImage(named:"phoneYellow") , mult: 0.48, height: CGFloat(100)) // index 1
        
        cellsFactory.addNoteCell(name: "Описание", text: place.descript, mult: 0.98, height: CGFloat(100)) // index 2
        
        coordinates(forAddress: place.adress!, completion: addRestOfCells(location:))
        
    }
    
    func addRestOfCells(location: CLLocationCoordinate2D?){
        
       
        guard let place = place else {return}
        
        if let location = location{
            annotation = PlaceMapAnnotation(title: place.name!, locationName: place.name!, discipline: place.adress!, coordinate: location)
            cellsFactory.addMapCell(name: "Построить маршрут", annotation: annotation!, mult: 1.00, height: CGFloat(250), image: UIImage(named: "routeYellow"))
        }
        //TODO: change color
        cellsFactory.addControlCell(name: "Редактировать", image: UIImage(named: "editYellow"), color: UIColor(red: 251, green: 164, blue: 58, alpha: 0.5), mult: 1.00, height: 50)
        cellsFactory.addControlCell(name: "Удалить", image: UIImage(named: "deleteRed"), color: UIColor(red: 255, green: 0, blue: 0, alpha: 1.0), mult: 1.00, height: 50)
        collectionView.reloadData()
    }
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
           guard let placemarks = placemarks else {
                print("no placemarks")
                completion(nil)
                return
            }
        completion(placemarks.first?.location?.coordinate)
    }
        
        
    }

    
    func updateCells(){
       guard let place = self.place else {return}
        name.text = place.name
        address.text = place.adress
        cellsFactory = PlaceVCCellFactory()
        
       cellsFactory.addDetailsCell(name: "Дата" , descript: place.date!.string , imageEmpty: UIImage(named:"calendar"), imageFilled: UIImage(named:"calendarYellow"), mult: 0.48, height: CGFloat(100))  // index 0
        
       cellsFactory.addDetailsCell(name: "Телефон", descript: place.phone, imageEmpty: UIImage(named:"phone"), imageFilled: UIImage(named:"phoneYellow") , mult: 0.48, height: CGFloat(100)) // index 1
       
       cellsFactory.addNoteCell(name: "Описание", text: place.descript, mult: 0.98, height: CGFloat(100)) // index 2
       
       coordinates(forAddress: place.adress!, completion: addRestOfCells(location:))
    }
    
    
    func dialNumber(numberString : String) {
        let number = numberString
     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
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

extension ShowPlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsFactory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    switch cellsFactory.getCellType(withIndex: indexPath.item){
//        case .details:
//            let cell = cellsFactory.getUICell(withIndex: indexPath.item, collectionView: collectionView, indexPath: indexPath) as! placeDetailsCollectionViewCell
//            return cell
//        case .note:
//            let cell = cellsFactory.getUICell(withIndex: indexPath.count, collectionView: collectionView, indexPath: indexPath) as! placeNoteCollectionViewCell
//
//            return cell
//        case .map:
//            let cell = cellsFactory.getUICell(withIndex: indexPath.item, collectionView: collectionView, indexPath: indexPath) as! PlaceMapCollectionViewCell
//            return cell
//        case .control:
//            let cell = cellsFactory.getUICell(withIndex: indexPath.item, collectionView: collectionView, indexPath: indexPath) as! PlaceControlCollectionViewCell
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCollectionViewCell", for: indexPath)
//            return cell
//
//        }

        let cell = cellsFactory.getUICell(withIndex: indexPath.item, collectionView: collectionView, indexPath: indexPath)
        return cell
    }
}

extension ShowPlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width * ( cellsFactory.getCellMultiplier(withIndex: indexPath.item) ?? CGFloat(0.25) )
        let yourHeight = cellsFactory.getCellHeight(withIndex: indexPath.item) ?? CGFloat(100.0)
        return CGSize(width: yourWidth, height: yourHeight)
    }
}

extension ShowPlaceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch cellsFactory.getCellName(withIndex: indexPath.item){
//        case "Дата":
//            let main = UIStoryboard(name: "Main", bundle: nil)
//            let dateVC = main.instantiateViewController(identifier: "PlaceDateViewController") as! PlaceDateViewController
//            dateVC.delegate = self
//            dateVC.presetDate = date
//            dateVC.minDate = trip?.dateFrom
//            dateVC.maxDate = trip?.dateTo
//            self.present(dateVC, animated: true)
//        case "Телефон":
//            let main = UIStoryboard(name: "Main", bundle: nil)
//            let phoneVC = main.instantiateViewController(identifier: "PlacePhoneViewController") as! PlacePhoneViewController
//            phoneVC.delegate = self
//            phoneVC.presetPhone = phone
//            self.present(phoneVC,animated: true)
//        case "Описание":
//            let main = UIStoryboard(name: "Main", bundle: nil)
//            let descVC = main.instantiateViewController(identifier: "PlaceDescriptionViewController") as! PlaceDescriptionViewController
//            descVC.delegate = self
//            descVC.presetDesc = descript
//            self.present(descVC,animated: true)
            
        case "Телефон":
            guard let place = place else {return}
            if place.phone != nil{
                if let phoneNumber = PhoneNumber(extractFrom: place.phone ?? ""){
                    
                    phoneNumber.makeACall()
                }
            } else {
                // Editing
                let main = UIStoryboard(name: "Main", bundle: nil)
                let editVC = main.instantiateViewController(identifier: "EditPlaceViewController") as! EditPlaceViewController
                editVC.place = self.place
                editVC.trip = self.trip
                editVC.delegate = self
                self.present(editVC,animated: true)
            }
        case "Построить маршрут":
            let main = UIStoryboard(name: "Main", bundle: nil)
            let routeVC = main.instantiateViewController(identifier: "PlaceCreateRouteViewController") as! PlaceCreateRouteViewController
            routeVC.annotation = self.annotation
            self.present(routeVC,animated: true)
        case "Редактировать":
            let main = UIStoryboard(name: "Main", bundle: nil)
            let editVC = main.instantiateViewController(identifier: "EditPlaceViewController") as! EditPlaceViewController
            editVC.place = self.place
            editVC.trip = self.trip
            editVC.delegate = self
            self.present(editVC,animated: true)
        case "Удалить":
            let choiceAlert = UIAlertController(title: "Вы уверены?", message: "Удаление необратимо", preferredStyle: .actionSheet)
            choiceAlert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: {action in
                //TODO: add delegate
                Place.deletePlace(place: self.place!)
                self.dismiss(animated: true, completion: nil)
                
            } ) )
            choiceAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: {action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(choiceAlert, animated: true, completion: nil)
        default:
            return
        }
    }
}


protocol ShowPlaceViewControllerDelegate {
    func update()
}

