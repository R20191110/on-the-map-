//
//  mapViewController.swift
//  on the map
//
//  Created by mac pro on 12/09/1440 AH.
//  Copyright © 1440 mac pro. All rights reserved.
//


import UIKit
import MapKit
//import CoreLocation

class mapViewController: UIViewController, MKMapViewDelegate {
    
    var studentLocations: [StudentLocation]!{
        return PublicVar.sared.studentLocation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.refreshAnnotations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (studentLocations == nil){
            refreshButton(self)
        } else {
            
            DispatchQueue.main.async {
                self.refreshAnnotations()}
        }
    }
    
   
    @IBOutlet weak var mapView: MKMapView!
 
    
    
    @IBAction func logOutButton(_ sender: Any) {
        UdacityAPI.deletSession{ (_,error)   in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.refreshAnnotations()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        UdacityAPI.parse.getStudentLocations{ (studentsLocations , error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.refreshAnnotations()}
        }
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
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            guard let openUrl = view.annotation?.subtitle, let url = URL(string: openUrl!) else {return}
            app.open(url, options: [:], completionHandler: nil)
        }
    }
}
extension mapViewController {
    
    func refreshAnnotations() {
        var annotations = [MKPointAnnotation]()
        UdacityAPI.parse.getStudentLocations{ ( studentsLocations, error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            } else {
                
                for studentsLocations in studentsLocations! {
                    
                    let lat = CLLocationDegrees(studentsLocations.latitude)
                    let long = CLLocationDegrees(studentsLocations.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = coordinate
                    annotation.title = "\(String(describing: studentsLocations.firstName)) \(String(describing: studentsLocations.lastName))"
                    annotation.subtitle = "\(String(describing: studentsLocations.mediaURL))"
                    annotations.append(annotation)
                    
                    self.mapView.addAnnotations(annotations)
                    
                } }
            
            self.mapView.addAnnotations(annotations)
        }
        
    }
    
}






