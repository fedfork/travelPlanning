//
//  PlaceDateViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 01.11.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PlaceDateViewController: UIViewController {

    var delegate: PlaceViewControllerDelegate?
    var presetDate: Date?
    var minDate: Date?
    var maxDate: Date?
    
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var date: UIDatePicker!
    
    
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
        
        date.minimumDate = minDate
        date.maximumDate = maxDate
        
        let defaultDate = minDate ?? Date()
        date.date = presetDate ?? defaultDate
        // Do any additional setup after loading the view.
    }
    
    @objc func cancelButtonPressed (sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed (sender: UIBarButtonItem){
        print ("date=\(date.date)")
        delegate?.updateDateField(date: date.date)
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
