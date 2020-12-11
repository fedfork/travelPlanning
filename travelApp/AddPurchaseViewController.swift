//
//  AddPurchaseViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 04.12.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class AddPurchaseViewController: UIViewController {

    
    @IBOutlet var navItem: UINavigationItem!
    
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var priceField: UITextField!
    
    @IBOutlet var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categories = Category.fetchAllCategories() ?? [Category]()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
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
    }
    
    var delegate: PurchasesViewControllerDelegate?
    
    var trip: Trip?
    
    var categories = [Category] ()

    @objc func cancelButtonPressed (sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed (sender: UIBarButtonItem){
        guard let trip1 = trip else {return}
        guard let nameFieldText = nameField.text else {return}
        
        //converting price string to double
        let priceString = priceField.text ?? "0.0"     //
        let priceValue = Double(priceString) ?? 0.0 //
        
        if nameFieldText == "" || priceValue == 0.0 { return }
        
       if pickerView.selectedRow(inComponent: 0) >= categories.count {return}
        let category = categories [pickerView.selectedRow(inComponent: 0)]
        
        Purchase.addNewPurchaseToTrip(trip: trip1, name: nameFieldText, descript: "", isBought: false, price: priceValue, categoryId: category.id!)
        
        delegate?.updateCategory(categoryId: nil, categoryName: nil)
        delegate?.updateWithFiltering()
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

extension AddPurchaseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row >= categories.count { return nil }
        return categories[row].name
    }
}
