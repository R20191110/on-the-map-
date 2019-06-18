//
//  listViewController.swift
//  on the map
//
//  Created by mac pro on 12/09/1440 AH.
//  Copyright © 1440 mac pro. All rights reserved.
//

import UIKit

class listViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if (studentLocations == nil){
            refreshButton(self)
        } else {
            
            DispatchQueue.main.async {
                self.tableView.reloadData() }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // refreshButton(self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    var studentLocations: [StudentLocation]!{
        return PublicVar.sared.studentLocation
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID" , for: indexPath as IndexPath)
        cell.textLabel!.text = studentLocations[indexPath.row].firstName
        cell.detailTextLabel!.text = studentLocations[indexPath.row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations?.count ?? 0    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = studentLocations[indexPath.row]
        let mediaURL = studentLocation.mediaURL
        let url = URL(string: mediaURL)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //let app = UIApplication.shared
        //  guard let openUrl: String = studentLocations.mediaURL , let url = URL(string:openUrl) else {return}
        // app.open(url, options: [:], completionHandler: nil)
        
    }
    
    

    @IBAction func logOutButton(_ sender: Any) {
        UdacityAPI.deletSession{ (_,error)   in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)}
        }
    }
    
    func refreshLocation(){
        UdacityAPI.parse.getStudentLocations{ (studentLocations , error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData() }
        }
    }
    
    
    @IBAction func refreshButton(_ sender: Any) {
        refreshLocation()
    }
    

   
}


