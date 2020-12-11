//
//  PlaceMapCollectionViewCell.swift
//  travelApp
//
//  Created by Fedor Korshikov on 02.11.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import MapKit

class PlaceMapCollectionViewCell: placeCollectionViewCell {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var map: MKMapView!
    
    var annotation: PlaceMapAnnotation?
    
        
        
    func setupLabels (name: String, image: UIImage?){
        self.name.text = name
        self.image.image = image
    }
    
    func configureMap(annotation: PlaceMapAnnotation) {
        self.annotation = annotation
        self.map.addAnnotation(annotation)
        let coord = annotation.coordinate
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        
        self.map.centerToLocation(location)
        
    }
    
    
}

extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 500
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
