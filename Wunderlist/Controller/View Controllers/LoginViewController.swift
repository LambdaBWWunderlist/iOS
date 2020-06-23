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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //saved dummy todo
        //        let fetchController = FetchController()
        //        let rep = TodoRepresentation(identifier: 2, completed: false, name: "do", recurring: "yeah", user_id: 1)
        //        let fetchedTodo = fetchController.fetchTodo(todoRep: rep)
        //        print(fetchedTodo?.user)
        
        updateLoginView()
    }
    
    
    private func updateLoginView() {
        
        
        loginButton.layer.cornerRadius = 6.0
        passwordTextField.isSecureTextEntry = true
        
        loginButton.layer.borderColor = UIColor.accentBlue.cgColor
        loginButton.layer.borderWidth = 2.0
        
        usernameTextField.layer.borderColor = UIColor.accentBlue.cgColor
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.layer.cornerRadius = 6.0
        usernameTextField.layer.borderWidth = 1.0
        
        
        
        emailTextField.layer.borderColor = UIColor.accentBlue.cgColor
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.cornerRadius = 6.0
        emailTextField.layer.borderWidth = 1.0
        
        passwordTextField.layer.borderColor = UIColor.accentBlue.cgColor
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerRadius = 6.0
        passwordTextField.layer.borderWidth = 1.0
    }
}
