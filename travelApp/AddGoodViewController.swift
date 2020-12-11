//
//  AddGoodViewController.swift
//  
//
//  Created by Fedor Korshikov on 21.03.2020.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class AddGoodViewController: UIViewController {

    var good: Good?
    var trip: Trip?
    var value: Int?
    var delegate : GoodsViewControllerDelegate?
    
    @IBAction func backButton(_ sender: Any) {
        // TODO: delegate was here
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var stepper: UIStepper!
    
    @IBAction func saveButton(_ sender: Any) {
        addGoodAndLeave()
    }
    
    @IBOutlet var nameLabel: UITextField!
    
   
    @IBOutlet var counterLabel: UILabel!
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        counterLabel.text = "\(stepper.intValue)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stepper.value = 1.0
    }
    
    func addGoodAndLeave() {
        guard let name = nameLabel.text else {return}
        guard let trip = trip else {return}
        if name == "" {// TODO: show message
            return
        }
        Good.addNewGoodToTrip(trip: trip, name: name, descript: "", isTaken: false, count: stepper.intValue)
        delegate?.update()
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

extension UIStepper {
    var intValue: Int {
        return Int(self.value)
    }
}
