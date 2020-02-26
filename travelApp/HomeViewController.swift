//
//  HomeViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 09.02.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var StackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StackView.addArrangedSubview(TripView())
        
        
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
