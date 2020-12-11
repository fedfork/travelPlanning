//
//  AddGoalViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 09.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class AddGoalViewController: UIViewController, UITextViewDelegate {

    var trip: Trip?
    var delegate: GoalsViewControllerDelegate?
    var editMode: Bool?
    var editableGoal: Goal?
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var descriptionField: UITextView!
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        addGoalAndLeave()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        //delegate was here
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionField.delegate = self
        descriptionField.text = "Введите..."
        descriptionField.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
        
        guard let editMode = editMode else {return}
        guard let editableGoal = editableGoal else {return}
        if editMode {
            nameField.text = editableGoal.name!
            descriptionField.text = editableGoal.descript
            descriptionField.textColor = UIColor.black
        }
    }
    
     func addGoalAndLeave() {
        guard let name = nameField.text else {return}
        guard let trip = trip else {return}
        if name == "" {// TODO: show message
            return
        }
        guard let editMode = editMode else {return}
        
        let desc = descriptionField.textColor != UIColor.lightGray ? descriptionField.text ?? "" : ""
        if !editMode {
            Goal.addNewGoalToTrip(trip: trip, name: name, descript: desc, isDone: false)
        } else {
            guard var editableGoal = editableGoal else { return }
            
            Goal.editGoal(goal: editableGoal, name: name, isDone: editableGoal.isDone, descript: desc)
        }
        delegate?.update()
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите..."
            textView.textColor = UIColor.lightGray
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
