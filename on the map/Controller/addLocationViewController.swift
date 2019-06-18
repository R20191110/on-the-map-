//
//  addLocationViewController.swift
//  on the map
//
//  Created by mac pro on 12/09/1440 AH.
//  Copyright © 1440 mac pro. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class addLocationViewController: UIViewController, MKMapViewDelegate {

  var location: StudentLocation?
    
    var locName: String!
    var link: String!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    func setup() {
        guard  let location = location else {
            return
        }
        let lat = CLLocationDegrees(location.latitude)
        let long = CLLocationDegrees(location.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString

        mapView.addAnnotation(annotation)
       let regionScop = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
       mapView.setRegion(regionScop, animated: true)
        
    }
    
    
    
    @IBAction func finishButton(_ sender: Any) {
        UdacityAPI.parse.postStudentLocations(self.location!){
            (error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
           // UserDefaults.standard.set(self.locName, forKey: "studentLocation")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }}
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pin!.canShowCallout = true
            pin!.pinTintColor = .red
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        
        return pin
    }
    
}
