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
        init(name: String, widthMult: CGFloat, counter: Int){
            self.name = name
            self.widthMultiplier = widthMult
            self.counter = counter
        }
    }

    
    var cellParameters: [cellParameter] = [cellParameter]()
    
    var trip: Trip?
    
    var places: [Place]?
    
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
        
        // configure collectionView layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
       
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 100.0
        
        //add gesture recognisers
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnCell(gesture:)))
//        collectionView.addGestureRecognizer(tapGesture)
        
        identifyCellParameters()
        
        // Do any additional setup after loading the view.
    }
    
    //configuring collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellParameters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCollectionViewCell
    
        cell.update(for: cellParameters[indexPath.item].name)
        cell.setupDesign()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // if no such element, do nothing
        if indexPath.item >= cellParameters.capacity { return }
        
        let selectedCellHeader = cellParameters[indexPath.item].name
        
        switch selectedCellHeader {
            case "Места":
                //instantiate and show places VC
                let placesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "placesVC") as! ShowAllPlacesViewController
                guard let currentTrip = trip else { print ("no current trip"); return }
                placesVC.trip = currentTrip
                
                
                placesVC.modalPresentationStyle = .fullScreen
                self.present(placesVC, animated: true, completion: nil)
            
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
        
        var parameter = cellParameter(name: "Места", widthMult: 0.62, counter: places?.count ?? 0)
        cellParameters.append(parameter)
        
        parameter = cellParameter(name: "Покупки", widthMult: 0.32, counter: places?.count ?? 0)
        cellParameters.append(parameter)
        
        
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

    

