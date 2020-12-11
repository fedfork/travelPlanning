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

class ShowAllGoodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GoodsViewControllerDelegate {
    
    func update() {
        goods = trip?.triptogood?.allObjects as? [Good] ?? [Good]()
        sortGoods()
        tableView.reloadData()
        
    }
    
    func valuesInCellChanged(checked: Bool, counter: Int, indexPath: IndexPath) {
        let good = goods[indexPath.item]
        Good.editGood(good: good, name: good.name!, isTaken: checked, descript: "", count: counter)
        update()
        return
    }
    
  
    @IBAction func addButtonPressed(_ sender: Any) {
        let strb = UIStoryboard(name: "Main", bundle: nil)
        let addGoodVC = strb.instantiateViewController(withIdentifier: "addGoodVC") as! AddGoodViewController
        addGoodVC.trip = trip
        addGoodVC.delegate = self
        self.present(addGoodVC, animated: true, completion: nil)
        
    }
    @IBOutlet var tableView: UITableView!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var trip: Trip?
    var goods = [Good] ()
    

    func sortGoods() {
        goods.sort(by: {
            return !$0.isTaken && $1.isTaken
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        update()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("goodsCount=\(goods.count)")
        return goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goodsTableViewCell") as! GoodsTableViewCell
        
        let currItem = goods[indexPath.item]
        cell.setFields(name: currItem.name ?? "", checkedImage: UIImage(named: "tickSquarePurple"), uncheckedImage: UIImage(named: "squareBlack"), checked: currItem.isTaken, counter: Int(currItem.count), indexPath: indexPath)
        cell.delegate = self
        
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
              
                if indexPath.item >= goods.count {return}
                let good = goods[indexPath.item]
                
                if Good.deleteGood(good: good){
                    goods.remove(at: indexPath.item)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                }
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

protocol GoodsViewControllerDelegate {
    func update()
    func valuesInCellChanged(checked: Bool, counter: Int, indexPath: IndexPath)
}
