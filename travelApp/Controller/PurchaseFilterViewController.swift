//
//  PurchaseFilterViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 04.12.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PurchaseFilterViewController: UIViewController {
    

    @IBOutlet var navItem: UINavigationItem!
    
    @IBOutlet var pickerView: UIPickerView!
    
    var delegate: PurchasesViewControllerDelegate?
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func cancelButtonPressed (sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed (sender: UIBarButtonItem){
        if pickerView.selectedRow(inComponent: 0) >= categories.count {return}
        let category = categories [pickerView.selectedRow(inComponent: 0)]
        
        delegate?.updateCategory(categoryId: category.id, categoryName: category.name)
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

extension PurchaseFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
