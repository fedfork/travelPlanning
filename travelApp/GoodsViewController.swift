//
//  GoodsViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 20.03.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON

class GoodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, refreshableDelegate {
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let strb = UIStoryboard(name: "Main", bundle: nil)
        let addGoodVC = strb.instantiateViewController(withIdentifier: "addGoodVC") as! AddGoodViewController
        addGoodVC.tripId = trip?.id
        addGoodVC.delegate = self
        self.present(addGoodVC, animated: true, completion: nil)
        
    }
    @IBOutlet var tableView: UITableView!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var goods = [Good] ()
    
    var trip: Trip?{
        didSet{
            goods = trip?.triptogood?.allObjects as? [Good] ?? [Good]()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("goodsCount=\(goods.count)")
        return goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goodsTableViewCell") as! GoodsTableViewCell
        
        let currItem = goods[indexPath.item]
        if currItem.isTaken {
            cell.setChecked()
        } else {
            cell.setUnchecked()
        }
        cell.setLabel(withText: currItem.name!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    

    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func refresh() {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
             if editingStyle == .delete {
    //            tableView.deleteRows(at: [indexPath], with: .fade)
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
