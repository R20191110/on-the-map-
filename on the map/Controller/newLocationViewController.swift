//
//  newLocationViewController.swift
//  on the map
//
//  Created by mac pro on 12/09/1440 AH.
//  Copyright © 1440 mac pro. All rights reserved.
//

import UIKit
import CoreLocation

class newLocationViewController: UIViewController {

    
    
   
    
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var Link: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    
    func activeIndicator() -> UIActivityIndicatorView {
        let acticityIndicator = UIActivityIndicatorView(style: .white)
        self.view.addSubview(acticityIndicator)
        self.view.bringSubviewToFront(acticityIndicator)
        acticityIndicator.center = self.view.center
        acticityIndicator.hidesWhenStopped = true
        acticityIndicator.startAnimating()
        return acticityIndicator
    
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationMap"{
            let vc = segue.destination as! addLocationViewController
            vc.location = (sender as! StudentLocation)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func findButton(_ sender: Any) {
        guard let locName = locationName.text?.trimmingCharacters(in: .whitespaces), !locName.isEmpty
            else {alert(title: "Waring", message: "location shoud not be empty")
                return
        }
        guard let link = Link.text?.trimmingCharacters(in: .whitespaces), !locName.isEmpty
            else {alert(title: "Waring", message: "enter link")
                return
        }
        getCoordinateFrom(location: locName) { (coordinate, error) in
            if error == nil {
                let studentLocations = StudentLocation.init(createdAt: "", firstName: "", lastName: "", latitude: coordinate!.latitude, longitude: coordinate!.longitude, mapString: locName, mediaURL: link, objectId: "", uniqueKey: "" , updatedAt: "")
                
                self.performSegue(withIdentifier: "locationMap", sender: studentLocations)
                
            }else {
                self.alert(title: "Error", message: "try another city")
                return
        }
        }
        
    }
    
    func getCoordinateFrom(location: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?,_ error: Error?)->()){
        let ai = activeIndicator()
        CLGeocoder().geocodeAddressString(location) { placemarks, error in
            ai.stopAnimating()
            completion(placemarks?.first?.location?.coordinate, error)
        }
        
    }
   
    
    @IBAction func cancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
