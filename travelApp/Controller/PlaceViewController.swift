//
//  PlaceViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 19.10.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PlaceViewControllerDelegate {
    
    var delegate: ShowAllPlacesViewControllerDelegate?
    
    @IBOutlet var navItem: UINavigationItem!
    
    @IBAction func endEditingName(_ sender: Any) {
        name = nameText.text != "" ? nameText.text : nil
    }
  
    @IBAction func endEditingAddress(_ sender: Any) {
        address = addressText.text != "" ? addressText.text : nil
    }
    
    func updatePhoneField(text: String?) {
        
        phone = text
        cellsFactory.updateDetailsCell(withIndex: 1, descript: phone ?? "", imageTypeIsFilled:  phone != nil )
        collectionView.reloadData()
    }
    
    func updateDateField(date: Date) {
        self.date = date
        
        cellsFactory.updateDetailsCell(withIndex: 0, descript: self.date?.string ?? "", imageTypeIsFilled:  self.date != nil )
        collectionView.reloadData()
        
        return
    }
    
    func updateDescriptField(text: String?) {
        descript = text
        
        cellsFactory.updateNoteCell(withIndex: 2, text: descript ?? "")
        collectionView.reloadData()
    }
    
    var trip: Trip?
    
    //places data fields
    var name: String?
    var address: String?
    
    var phone: String?
    var date: Date?
    var descript: String?
    
    var googlePlace: GoogleMapsAPIPlace?
    var cellsFactory = PlaceVCCellFactory()
    
    enum controllerMode{
        case auto, manually
    }
   
    @IBOutlet var nameText: UITextField!
    @IBOutlet var addressText: UITextField!
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureNavItem()
        //initializing cells in factory
        
        //filling fields from google place
        
        name = googlePlace?.name != "" ? googlePlace?.name : nil
        address = googlePlace?.address != "" ? googlePlace?.address : nil
        phone = googlePlace?.phone != "" ? googlePlace?.phone : nil
        descript = ""
        
        //filling text fields
        nameText.text = name
        addressText.text = address
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 20.0
        
        
        
        cellsFactory = PlaceVCCellFactory()
        initiateCellsFactory()
        
        
        
    }
    
    func configureNavItem(){
        
        self.navItem.setHidesBackButton(true, animated: true)
        //setting button for navItem
        var cancelB = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelButtonPressed(sender:))
        )
        var saveB = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(saveButtonPressed(sender:))
        )
        self.navItem.rightBarButtonItem = saveB
        self.navItem.leftBarButtonItem = cancelB
    }
    
    @objc func cancelButtonPressed (sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed (sender: UIBarButtonItem){
        
        guard let trip = self.trip else { print ("no trip here. return"); return }
       
        
        if let name = self.name, let address = self.address, let date = self.date, let descript = self.descript {
            
            Place.addNewPlaceToTrip(trip: trip, userId: trip.userId!, adress: address, checked: false, date: date, description: descript, name: name, phone: phone)
            delegate?.refetchData()
            self.dismiss(animated: true, completion: nil)
        } else {
            
            //TODO: Add notification
        }
    }
    
    func initiateCellsFactory(){
        //TODO: set images
        
        cellsFactory.addDetailsCell(name: "Дата", descript: nil, imageEmpty: UIImage(named:"calendar"), imageFilled: UIImage(named:"calendarYellow"), mult: 0.48, height: CGFloat(100))
        cellsFactory.addDetailsCell(name: "Телефон", descript: phone, imageEmpty: UIImage(named:"phone"), imageFilled: UIImage(named:"phoneYellow") , mult: 0.48, height: CGFloat(100))
        cellsFactory.addNoteCell(name: "Описание", text: nil, mult: 0.98, height: CGFloat(100))
        
    }
    
    func updateCellsInFactory(){
        cellsFactory.updateDetailsCell(withIndex: 0, descript: date?.string ?? "", imageTypeIsFilled: date != nil) //date
        cellsFactory.updateDetailsCell(withIndex: 1, descript: phone ?? "", imageTypeIsFilled: phone != nil) //phone
        cellsFactory.updateNoteCell(withIndex: 2, text: descript ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsFactory.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = cellsFactory.getUICell(withIndex: indexPath.count, collectionView: collectionView, indexPath: indexPath)
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width * ( cellsFactory.getCellMultiplier(withIndex: indexPath.item) ?? CGFloat(0.25) )
        let yourHeight = CGFloat(100.0)
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch cellsFactory.getCellName(withIndex: indexPath.item){
        case "Дата":
            let main = UIStoryboard(name: "Main", bundle: nil)
            let dateVC = main.instantiateViewController(identifier: "PlaceDateViewController") as! PlaceDateViewController
            dateVC.delegate = self
            dateVC.presetDate = date
            dateVC.minDate = trip?.dateFrom
            dateVC.maxDate = trip?.dateTo
            self.present(dateVC, animated: true)
        case "Телефон":
            let main = UIStoryboard(name: "Main", bundle: nil)
            let phoneVC = main.instantiateViewController(identifier: "PlacePhoneViewController") as! PlacePhoneViewController
            phoneVC.delegate = self
            phoneVC.presetPhone = phone
            self.present(phoneVC,animated: true)
        case "Описание":
            let main = UIStoryboard(name: "Main", bundle: nil)
            let descVC = main.instantiateViewController(identifier: "PlaceDescriptionViewController") as! PlaceDescriptionViewController
            descVC.delegate = self
            descVC.presetDesc = descript
            self.present(descVC,animated: true)
        default:
            return
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
    


extension Date {
    var string:String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: self)
    }
}

protocol PlaceViewControllerDelegate {
    func updatePhoneField (text: String?)
    func updateDateField (date: Date)
    func updateDescriptField (text: String?)
}
