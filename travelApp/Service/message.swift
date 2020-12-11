//
//  message.swift
//  travelApp
//
//  Created by Fedor Korshikov on 08.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import UIKit

func displayMessage (vc: UIViewController,title: String, message: String){
        DispatchQueue.main.async {
        
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            vc.present (alert, animated: true, completion: nil)
            
//            alert.addAction(UIAlertAction(title: "ShowAndDismiss", style: .cancel, handler: {
//
//            }))
            let timer2 = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                alert.dismiss(animated: true, completion: nil)
            }
            
        }
    }
