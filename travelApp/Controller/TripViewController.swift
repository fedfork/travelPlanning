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

    //describes one cell - size, description and counter
    
    struct cellParameter {
        var name : String
        var widthMultiplier: CGFloat
        var counter: Int
        var image: UIImage?
        init(name: String, widthMult: CGFloat, counter: Int, image: UIImage?){
            self.name = name
            self.widthMultiplier = widthMult
            self.counter = counter
            self.image = image
        }
    }
    
    
    
    var cellParameters: [cellParameter] = [cellParameter]()
    
    var tripId: String?
    
    var trip: Trip? {
        didSet {
            
            DispatchQueue.main.async {
                
                self.tripName.text = self.trip?.name
            }
            
            identifyCellParameters()
        }
    }
    
    var places: [Place]?
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tripName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // configure collectionView layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
       
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 20.0
        
        //add gesture recognisers
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnCell(gesture:)))
//        collectionView.addGestureRecognizer(tapGesture)
        
        //притаскиваем из кор даты трип и помещаем его в trip
       
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let tripId = tripId else {
                   print ("no trip ID, ret"); return }
               guard let  trip1 = Trip.fetchTripById(id: tripId) else {
                   print("could not fetch trip by tripId"); //TODO: show an error message
                   return}
               trip=trip1
    }
    
    //configuring collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellParameters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellParameters[indexPath.item].name == "Даты" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuDateCollectionViewCell", for: indexPath as IndexPath) as! MenuDateCollectionViewCell
            
            cell.update(for: trip!.getDateStringFromTo() )
            cell.setupDesign()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCollectionViewCell
            cell.update(for: cellParameters[indexPath.item].name, counter: cellParameters[indexPath.item].counter, image: cellParameters[indexPath.item].image)
            cell.setupDesign()
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // if no such element, do nothing
        if indexPath.item >= cellParameters.capacity { return }
        if indexPath.item == 0 { return }
        
        
        let selectedCellHeader = cellParameters[indexPath.item].name
        
        guard let currentTrip = trip else { print ("no current trip"); return }
        
        switch selectedCellHeader {
            case "Места":
                //instantiate and show places VC
                let placesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "placesVC") as! ShowAllPlacesViewController
                
                placesVC.trip = currentTrip
            
                placesVC.modalPresentationStyle = .fullScreen
                self.present(placesVC, animated: true, completion: nil)
            
                return
            
            case "Вещи к сбору":
                let strb = UIStoryboard(name: "Main", bundle: nil)
                let goodsVC = strb.instantiateViewController(withIdentifier: "goodsVC") as! ShowAllGoodsViewController
                goodsVC.trip = currentTrip
                
                goodsVC.modalPresentationStyle = .fullScreen
                
                self.present(goodsVC, animated: true, completion: nil)
                
            case "Цели":
                let strb = UIStoryboard(name: "Main", bundle: nil)
                let goalsVC = strb.instantiateViewController(withIdentifier: "goalsVC") as! ShowAllGoalsViewController
                goalsVC.trip = currentTrip
                
                goalsVC.modalPresentationStyle = .fullScreen
                
                self.present(goalsVC, animated: true, completion: nil)
            
                
                return
            
            case "Покупки":
                let strb = UIStoryboard(name: "Main", bundle: nil)
                let purchasesVC = strb.instantiateViewController(withIdentifier: "PurchasesViewController") as! PurchasesViewController
                purchasesVC.trip = currentTrip
                
                purchasesVC.modalPresentationStyle = .fullScreen
                
                self.present(purchasesVC, animated: true, completion: nil)
            
                
                return
            default:
                return
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width * cellParameters[indexPath.item].widthMultiplier
        let yourHeight = CGFloat(100.0)
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    

    //finished configuring colletionView
    
    //configuring gesture handlers
    
//    @objc func handleTapOnCell(gesture : UITapGestureRecognizer!) {
//       if gesture.state != .ended {
//           return
//       }
//       let p = gesture.location(in: self.collectionView)
//
//       if let indexPath = self.collectionView.indexPathForItem(at: p) {
//           // get the cell at indexPath (the one you long pressed)
//           let cell = self.collectionView.cellForItem(at: indexPath)
//           // we got current trip, now display q/alert about deleting
//
//           print ("tapped on trip \(cellParameters[indexPath.item].name)")
//
////           let choiceAlert = UIAlertController(title: " Выберите действие", message: "Поездка \(trips![indexPath.item].Name)", preferredStyle: .actionSheet)
////           choiceAlert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {action in
////               self.deleteTrip(tripId: self.trips![indexPath.item].Id)
////           } ) )
////           self.present(choiceAlert, animated: true, completion: nil)
//
//       } else {
//           print("couldn't find index path")
//       }
//    }
    
    
        


    func identifyCellParameters() {
        
      
        var parameter = cellParameter(name: "Даты", widthMult: 1.0, counter: 0, image: nil)
        if cellParameters.capacity == 0{
            cellParameters.append(parameter)
            cellParameters.append(parameter)
            cellParameters.append(parameter)
            cellParameters.append(parameter)
            cellParameters.append(parameter)
        }
        
        cellParameters[0] = parameter
        
        parameter = cellParameter(name: "Места", widthMult: 0.62, counter: trip?.triptoplace?.count ?? 0, image: UIImage(named: "placesMenuWhite"))
        cellParameters[1] = parameter
        
        parameter = cellParameter(name: "Цели", widthMult: 0.32, counter: trip?.triptogoal?.count ?? 0, image: UIImage(named: "tickWhite"))
        cellParameters[2] = parameter
        
        parameter = cellParameter(name: "Вещи к сбору", widthMult: 1.0, counter: trip?.triptogood?.count ?? 0, image: UIImage(named: "suitcaseWhite"))
        cellParameters[3] = parameter
        
        parameter = cellParameter(name: "Покупки", widthMult: 0.62, counter: trip?.triptogood?.count ?? 0, image: UIImage(named: "cartWhite"))
        cellParameters[4] = parameter
        
        showCvData()
    }
    
    
    func showCvData (){
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let yourWidth = collectionView.bounds.width - 20
//        let yourHeight = yourWidth/3
//
//        return CGSize(width: yourWidth, height: yourHeight)
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    

