//
//  PlacesOnMapViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 04.11.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import MapKit

class PlacesOnMapViewController: UIViewController {

    @IBOutlet var map: MKMapView!
    @IBOutlet var navBar: UINavigationItem!
    
    var annotations: [PlaceMapAnnotation]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var cancelB = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelButtonPressed(sender:))
        )
        self.navBar.leftBarButtonItem = cancelB
        
        configureMap()
    }

    @objc func cancelButtonPressed(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureMap() {
        
        guard let annotations = annotations else {return}
        var coordinates = [CLLocationCoordinate2D]()
        for annotation in annotations {
            
            self.map.addAnnotation(annotation)
            let coord = annotation.coordinate
            
            coordinates.append(coord)
        }
        
        map.centerAroundLocations(coordinates)
        
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

extension MKMapView {
  func centerAroundLocations(
    _ coordinates: [CLLocationCoordinate2D]) {
    
    var minLat = coordinates[0].latitude,
    maxLat = coordinates[0].latitude,
    minLong = coordinates[0].longitude,
    maxLong = coordinates[0].longitude
    for coordinate in coordinates {
        
        minLat = min(minLat, coordinate.latitude)
        maxLat = max(maxLat, coordinate.latitude)
        minLong = min(minLong, coordinate.longitude)
        maxLong = max(maxLong, coordinate.longitude)
    }
    let coordCenter = CLLocationCoordinate2D(latitude: minLat + (maxLat - minLat) / 2, longitude: minLong + (maxLong - minLong) / 2 )
    let span = MKCoordinateSpan(latitudeDelta: abs(maxLat-minLat) * 1.2, longitudeDelta: abs(maxLong - minLong) * 1.2)
    let coordinateRegion = MKCoordinateRegion(center: coordCenter, span: span)
    
    setRegion(coordinateRegion, animated: true)
  }
}


