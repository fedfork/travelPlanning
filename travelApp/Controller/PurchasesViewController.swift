//
//  PurchasesViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 03.12.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class PurchasesViewController: UIViewController, PurchasesViewControllerDelegate {
    func cellCheckedUnchecked(indexPath: IndexPath, checked: Bool) {
        let purchase = purchases[indexPath.item]
        Purchase.editPurchase(purchase: purchase, name: purchase.name!, descript: purchase.descript!, isBought: checked, price: purchase.price, categoryId: purchase.categoryId!)
        updateWithFiltering()
    }
    
    func updateCategory(categoryId: String?, categoryName: String?) {
        self.categoryId = categoryId
        self.categoryName = categoryName

        if let categoryName = categoryName {
            categoriesLabel.text = "Категория: \(categoryName)"
            filterButton.setTitle("Сбросить" , for: .normal)
        } else {
            categoriesLabel.text = "Все категории"
            filterButton.setTitle("Фильтр" , for: .normal)
        }
    }
    
    func updateWithFiltering() {
        guard let trip = trip else { return }
        let purchasesNoFiltering = trip.triptopurchase!.allObjects as! [Purchase]
        
        let showBought = selector.selectedSegmentIndex == 1
                if let categoryId = categoryId {
            purchases = purchasesNoFiltering.filter { element in
                return element.categoryId! == categoryId && element.isBought == showBought
            }
        } else {
            purchases = purchasesNoFiltering.filter { element in
                return element.isBought == showBought
            }
        }
        tableView.reloadData()
    }
    
    
    @IBOutlet var categoriesLabel: UILabel!
    

    @IBOutlet var filterButton: UIButton!
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var tableView: UITableView!
    

    
    @IBOutlet var selector: UISegmentedControl!
    
    @IBAction func selectorValueChanged(_ sender: Any) {
        updateWithFiltering()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let addVC = main.instantiateViewController(identifier: "AddPurchaseViewController") as! AddPurchaseViewController
        addVC.delegate = self
        addVC.trip = trip
        self.present(addVC,animated: true)
    }

    @IBAction func diagramButtonPressed(_ sender: Any) {
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let diagramVC = main.instantiateViewController(identifier: "PieChartViewController") as! PieChartViewController
        diagramVC.trip = trip
        self.present(diagramVC,animated: true)
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        if categoriesLabel.text == "Все категории" {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let filterVC = main.instantiateViewController(identifier: "PurchaseFilterViewController") as! PurchaseFilterViewController
            filterVC.delegate = self
            self.present(filterVC,animated: true)
        } else {
            updateCategory(categoryId: nil, categoryName: nil)
            updateWithFiltering()
        }
    }
    
    var trip: Trip?
    
    //selectedCategory
    var categoryId: String?
    var categoryName: String?
    
    var purchases: [Purchase] = [Purchase]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWithFiltering()
        tableView.delegate = self
        tableView.dataSource = self
        print ( Category.fetchAllCategories() )
        
        // Do any additional setup after loading the view.
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

protocol PurchasesViewControllerDelegate {
    func cellCheckedUnchecked (indexPath: IndexPath, checked: Bool) //cell calls this
    func updateCategory(categoryId: String?, categoryName: String?) //called by filter controller, also by adding/editing controller
    func updateWithFiltering() //
}

extension PurchasesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchasesTableViewCell") as! PurchasesTableViewCell
        
        let currItem = purchases[indexPath.item]
        cell.setFields(name: currItem.name ?? "", category: Category.getCategoryNameById(id: currItem.categoryId ?? "") ?? "",
                       price: currItem.price, checkedImage: UIImage(named: "tickSquarePurple"), uncheckedImage: UIImage(named: "squareBlack"), checked: currItem.isBought,  indexPath: indexPath)
        
        cell.delegate = self
        
        return cell
    }
    
}
