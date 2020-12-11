//
//  placePhoneViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 29.10.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PlacePhoneViewController: UIViewController {


    
    var delegate: PlaceViewControllerDelegate?
    var presetPhone: String?
    
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var phone: UITextField!
    
    @IBAction func readyButtonPressed(_ sender: Any) {
        guard let phoneFieldText = phone.text else {return}
        
        guard let delegate = delegate else {return}
        delegate.updatePhoneField(text: phoneFieldText != "" ?  phoneFieldText : nil)
        
        
        self.dismiss(animated: true, completion: nil)
       
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting button for navItem
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
        
        phone.text = presetPhone
        // Do any additional setup after loading the view.
    }
    
    @objc func cancelButtonPressed (sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed (sender: UIBarButtonItem){
        guard let phoneFieldText = phone.text else {return}
        
        delegate?.updatePhoneField(text: phoneFieldText != "" ?  phoneFieldText : nil)
        self.dismiss(animated: true, completion: nil)
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
