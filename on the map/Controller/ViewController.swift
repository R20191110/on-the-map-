//
//  ViewController.swift
//  on the map
//
//  Created by mac pro on 12/09/1440 AH.
//  Copyright © 1440 mac pro. All rights reserved.
//

import UIKit

extension UIViewController {
func alert(title: String, message: String ){
    let alert = UIAlertController(title: title , message: message, preferredStyle:.alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    }
    
}

class ViewController: UIViewController, UITextFieldDelegate {
    func enableUI(value: Bool){
        DispatchQueue.main.async {
            self.email.isUserInteractionEnabled = !value
            self.password.isUserInteractionEnabled = !value
            self.signIn.isEnabled = !value
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()

    }
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
  
    
    @IBAction func signInButton(_ sender: Any) {
        enableUI(value: true)
        if (email.text!.isEmpty) || (password.text!.isEmpty) {
            
            self.alert(title: "Waring", message: "please enter your email and password")
            enableUI(value: false)
            return
            
        } else {   UdacityAPI.postSession(with: email.text!, Password: password.text! ) { (result, error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                self.enableUI(value: false)
                return
            }
            if let error = result?["error"] as? String {
                self.alert(title: "Error", message: error)
                self.enableUI(value: false)
                return
            }
            if let session = result?["session"] as? [String:Any], let _ = session["id"] as? String{
                UdacityAPI.deletSession{ (_,error)   in
                    if let error = error {
                        self.alert(title: "Error", message: error.localizedDescription)
                        self.enableUI(value: false)
                        return
                }
                self.enableUI(value: false)
                    DispatchQueue.main.async {
                        self.email.text = ""
                        self.password.text = ""
                       self.performSegue(withIdentifier: "tabVC", sender: self)
                    }

            }
                self.enableUI(value: false)
        }
        
    }
}

    
}
    @IBAction func signUpButton(_ sender: Any) {
        if let url = NSURL(string: "https://auth.udacity.com/sign-in?next=https://classroom.udacity.com/authenticated") {
            UIApplication.shared.openURL(url as URL)
        }
    
    }}

// keboard functions:

extension ViewController {
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if password.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }}
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
        
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

