//
//  mapAnnotations.swift
//  travelApp
//
//  Created by Fedor Korshikov on 02.11.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import MapKit

class PlaceMapAnnotation: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let coordinate: CLLocationCoordinate2D
    
  init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
   
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}
