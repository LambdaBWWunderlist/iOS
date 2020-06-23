//
//  LoginViewController.swift
//  Wunderlist
//
//  Created by Dahna on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var loginSegControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateLoginView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLoginView()
    }
    
    private func updateLoginView() {
        loginButton.layer.cornerRadius = 10.0
        passwordTextField.isSecureTextEntry = true
        
        loginButton.layer.borderColor = UIColor.accentBlue.cgColor
        loginButton.layer.borderWidth = 1.0
        
        usernameTextField.layer.borderColor = UIColor.accentBlue.cgColor
//        usernameTextField.borderStyle = .roundedRect
        usernameTextField.layer.cornerRadius = 10.0
        usernameTextField.layer.borderWidth = 1.0
    }
}
