//
//  PlaceCreateRouteViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 03.11.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import MapKit

class PlaceCreateRouteViewController: UIViewController {
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var navItem: UINavigationItem!
    
    
    var annotation: PlaceMapAnnotation?
    
    func configureMap(annotation: PlaceMapAnnotation) {
        self.annotation = annotation
        self.map.addAnnotation(annotation)
        let coord = annotation.coordinate
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        
        self.map.centerToLocation(location)
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        //TODO: createRoute
        guard let annotation = annotation else { return }
        openMapsAppWithDirections(to: annotation.coordinate, destinationName: annotation.locationName ?? "")
    }
    
    
    @objc func cancelButtonPressed(sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting button for navItem
        var cancelB = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelButtonPressed(sender:))
        )
        self.navItem.leftBarButtonItem = cancelB
        
        guard let annotation = annotation else {return}
        
        configureMap(annotation: annotation)
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
