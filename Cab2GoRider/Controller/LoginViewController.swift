//
//  ViewController.swift
//  Cab2GoRider
//
//  Created by Yevhenii on 18.04.2018.
//  Copyright © 2018 Yevhenii. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK:- Other Methods
    
    private func alertUser(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerAction_OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alerAction_OK)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            UsersAuthorizationManager.authManager.login(email: emailTextField.text!, password: passwordTextField.text!, loginHandler: { message in
                
                if message != nil {
                    
                    self.alertUser(title: "Authentication Error", message: message!)
                    
                } else {
                    
                    print("Login Completed")
                    
                }
                
            })
            
        }
    }
    
    @IBAction func sugnUpButtonPressed(_ sender: UIButton) {
    }
    
}

