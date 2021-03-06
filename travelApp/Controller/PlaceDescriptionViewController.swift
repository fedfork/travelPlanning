//
//  PlaceDescriptionViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 30.10.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PlaceDescriptionViewController: UIViewController {

    var delegate: PlaceViewControllerDelegate?
    var presetDesc: String?
    
    @IBOutlet var desc: UITextView!
    
    @IBOutlet var navItem: UINavigationItem!
    
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
        
        desc.text = presetDesc
        // Do any additional setup after loading the view.
    }
    
    @objc func cancelButtonPressed (sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed (sender: UIBarButtonItem){
        guard let descFieldText = desc.text else {return}
        
        delegate?.updateDescriptField(text: descFieldText)
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
