//
//  syncViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 28.07.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class SyncViewController: UIViewController {
    
    var delegate: RefreshableDelegate? = nil

    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sc = StorageCoordinator()
        
        if !sc.synchroniseWithServer() { print ("went wrong") }
        let places = Place.fetchAllPlaces(changed: false)
        print ("Мои места в кор дате:")
        print (places)
        
        delegate?.refresh()
        
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
