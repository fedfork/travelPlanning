//
//  API.swift
//  travelApp
//
//  Created by Fedor Korshikov on 03.12.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import SwiftyJSON

class API {
    public func getCategories() -> JSON? {
        let myUrl = URL(string: Global.apiUrl + "/category/getall")

        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"
        request.addValue ("application/json", forHTTPHeaderField: "content-type")
        
        var recievedJson: JSON?
        
        let group = DispatchGroup()

        let task = URLSession.shared.dataTask (with: request, completionHandler: { data, response, error in

            if error != nil || data == nil {
                group.leave()
                return
            }

            print (data)
            
            let json = try? JSON(data: data!)
            
            recievedJson = json
            
            group.leave()
            
            })
        group.enter()
        DispatchQueue.global(qos: .default).async {
            
            task.resume()
        }
        
        
        group.wait()
        
        return recievedJson
    }
}
