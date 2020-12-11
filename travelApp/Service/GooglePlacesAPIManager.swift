//
//  GooglePlacesAPIManager.swift
//  travelApp
//
//  Created by Fedor Korshikov on 21.10.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit

class GooglePlacesAPIManager {
    public static func retrievePlacesFromGoogleAPI(searchText: String)->[GoogleMapsAPIPlace]?{
        let url = URL(string:"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyBVKOuOwL-7oypGUAGV2KdzZ0LcXArj62w&input=\(searchText)&language=ru".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        guard let url1 = url else {print ("wrong url"); return nil}
        var placesUrlRequest = URLRequest(url: url1)
        placesUrlRequest.httpMethod = "GET"
        var responseJson: JSON?
        
        let group = DispatchGroup()
        
        let getPlacesListDataTask = URLSession.shared.dataTask(with: placesUrlRequest, completionHandler: {
            data, response, error in
            if let currData = data {
                responseJson = try? JSON(data: currData)
            }
            group.leave()
        })
        
        group.enter()
        DispatchQueue.global(qos: .default).async {
            getPlacesListDataTask.resume()
        }
        group.wait()
        
        //parsing places json
        guard let respJson = responseJson else {print ("recieved bad json"); return nil}
        
        if !respJson["predictions"].exists() {
            print ("recieved bad json"); return nil
        }
        
        print ("respJSON:")
        print (respJson["predictions"])
        
        let group2 = DispatchGroup()
        
        var resArray = [GoogleMapsAPIPlace]()
        
        for (num,place) in respJson["predictions"] {
            //performing place details request for every place
            if !place["place_id"].exists() {
                print("no place id here"); continue
            }
            guard let place_id = place["place_id"].string else {print ("wrong place id here"); continue}
            
            print ("placeID=\(place_id)")
            
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyBVKOuOwL-7oypGUAGV2KdzZ0LcXArj62w&fields=name,formatted_address,international_phone_number&place_id=\(place_id)&language=ru".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            guard let placeDetailsURL = url else {print("wrong url"); continue}
            var placeDetailsRequest = URLRequest(url: placeDetailsURL)
            placeDetailsRequest.httpMethod = "GET"
            
            var respJSON: JSON?
            let getPlaceDetailsTask = URLSession.shared.dataTask(with: placeDetailsRequest, completionHandler: {
                data, response, error in
                
                if error != nil || data == nil {
                    print ("bad serv response")
                    print (error)
                    group2.leave()
                    return
                }
                respJSON = try? JSON(data: data!)
                
                guard let responseJSON = respJSON else {print ("received bad json"); group2.leave(); return}
                
                print ("responseJSON:")
                print (responseJSON)
                if !responseJSON["result"].exists() {
                    print ("received bad json"); group2.leave(); return
                }
                
                guard let name = responseJSON["result"]["name"].string,
                    let address = responseJSON["result"]["formatted_address"].string else {
                    print ("received bad json"); group2.leave(); return
                }
                let phone = responseJSON["result"]["international_phone_number"].string ?? ""
                var placeFromAPI = GoogleMapsAPIPlace(name: name, address: address, phone: phone)
                resArray.append (placeFromAPI)
                
                group2.leave()
                
                })
            group2.enter()
            DispatchQueue.global(qos: .default).async{
                getPlaceDetailsTask.resume()
            }
        }
        
      
        group2.wait()
        
    
        return resArray
    }
    public static func geocodeBatchOfAddresses(places: [Place]) -> [PlaceMapAnnotation]?{
        
        let group = DispatchGroup()
        var annotations: [PlaceMapAnnotation]?
        
        for place in places {
            let url = URL(string:"https://maps.googleapis.com/maps/api/geocode/json?address=\(place.adress)&key=AIzaSyBVKOuOwL-7oypGUAGV2KdzZ0LcXArj62w".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            guard let url1 = url else {print ("wrong url"); return nil}
            var placesUrlRequest = URLRequest(url: url1)
            placesUrlRequest.httpMethod = "GET"
            
            let getAnnotationDataTask = URLSession.shared.dataTask(with: placesUrlRequest, completionHandler: {
                data, response, error in
                
                if let currData = data {
                    let respJson = try? JSON(data: currData)
                    
                    guard let responseJson = respJson else {group.leave(); return}
                    print ("respJson=\(responseJson)")

                    guard let array = responseJson["results"].array else {group.leave(); return}
                    if array.isEmpty {group.leave(); return}
                    
                    guard let lat = responseJson["results"].arrayValue[0]["geometry"]["location"]["lat"].double else {
                        
                        
                        group.leave();
                        return}
                    
                    guard let long = responseJson["results"].arrayValue[0]["geometry"]["location"]["lng"].double else {group.leave(); return}
                    //filling annotation
                    let annotation = PlaceMapAnnotation(title: place.name!, locationName: place.name!, discipline: place.adress!, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    if annotations == nil {
                        annotations = [PlaceMapAnnotation]()
                    }
                    annotations!.append(annotation)
                }
                group.leave()
            })
            group.enter()
            DispatchQueue.global(qos: .default).async {
                getAnnotationDataTask.resume()
            }
            
        }
        
        group.wait()
        return annotations
    }
}
