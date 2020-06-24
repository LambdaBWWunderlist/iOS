//
//  LoginViewController.swift
//  Wunderlist
//
//  Created by Dahna on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var togglePassword: Bool = false
    let toggleButton = UIButton(type: .custom)

    
    // MARK: - Outlets
    
    @IBOutlet var loginSegControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        togglePassword.toggle()
        
    }
    
    
    override func viewDidLoad() {
        
//        User(identifier: 7, username: AuthService.testUser.username, email: "thehammersvpa@gmail.com")
//        do {
//            try CoreDataStack.shared.save()
//        } catch {
//        print("\(error) saving CoreData user")
//        }
        let authService = AuthService()
        authService.loginUser(with: AuthService.testUser.username, password: AuthService.testUser.password!) {
            print("logged in")
        }
        
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
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
        
        passwordTextField.rightView = toggleButton
        
        #warning("work in progress")
        
//        toggleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
//        toggleButton.frame = CGRect(x: CGFloat(frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
//        toggleButton.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
//        passwordTextField.rightView = toggleButton
//        passwordTextField.rightViewMode = .always
    }
}

