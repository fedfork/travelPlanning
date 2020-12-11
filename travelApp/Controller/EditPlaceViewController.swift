//
//  EditPlaceViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 03.11.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class EditPlaceViewController: UIViewController {

    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var name: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var date: UIDatePicker!
    
    var place: Place?
    var delegate: ShowPlaceViewControllerDelegate?
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var cancelB = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelButtonPressed(sender:))
        )
        var saveB = UIBarButtonItem(
            title: "Готово",
            style: .plain,
            target: self,
            action: #selector(saveButtonPressed(sender:))
        )
        self.navItem.rightBarButtonItem = saveB
        self.navItem.leftBarButtonItem = cancelB
        
        guard let place = place else {return}
        name.text = place.name
        address.text = place.adress
        phone.text = place.phone
        date.date = place.date!
        // Do any additional setup after loading the view.
    }
    
    @objc func cancelButtonPressed (sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed (sender: UIBarButtonItem){
        guard let place = place else {return}
        guard let name = name.text else {return}
        guard let address = address.text else {return}
        guard let phone = phone.text else {return}
        if name == "" || address == "" {
            //TODO: message
            return
        }
        let date = self.date.date
        if Place.editPlace(place: place, adress: address, checked: place.checked, date: date, description: place.descript!, name: name, phone: phone != "" ? phone : nil) {
            delegate?.update()
            self.dismiss(animated: true, completion: nil)
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
