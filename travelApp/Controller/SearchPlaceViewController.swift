//
//  SearchPlaceViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 19.10.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class SearchPlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var searchTextField: UITextField!
    
    @IBAction func searchTextFieldEditingChanged(_ sender: Any) {
        if let text = searchTextField.text{
            
            places = GooglePlacesAPIManager.retrievePlacesFromGoogleAPI(searchText: text)
        }
    }
    
    @IBAction func manualButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showPlacesVCsegue", sender: nil)
    }
    
    var places: [GoogleMapsAPIPlace]? {
        didSet {
            
            
            tableView.reloadData()
            
            updateTableViewHeight()
        }
    }
    
    var trip: Trip?
    
    var delegate: ShowAllPlacesViewControllerDelegate?
    
    @IBOutlet var tableView: UITableView!
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPlacesTableViewCell") as! SearchPlacesTableViewCell
        cell.setLabels(name: places?[indexPath.item].name ?? "", address: places?[indexPath.item].address ?? "")
        return cell
    }
    
    //to set dynamic height of tableView
    func updateTableViewHeight() {
        
        
        tableViewHeightConstraint.constant = tableView.contentSize.height
        print ("height=\( tableView.contentSize.height)")
//        var frame = tableView.frame
//        frame.size.height = tableView.contentSize.height
//
//        tableView.frame = frame
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segId = segue.identifier else {print ("segue without identifier"); return}
        if segId != "showPlacesVCsegue" { return }
        let destinationVC = segue.destination as! PlaceViewController
        destinationVC.delegate = delegate
        destinationVC.trip = self.trip
        if !(sender is UITableViewCell) {
            return
        }
        
        
        guard let selectedIndex = tableView.indexPath(for: sender as! UITableViewCell), let places = places else {return }
        
        destinationVC.googlePlace = places[selectedIndex.item]
       
        
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
