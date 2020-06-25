//
//  LoginViewController.swift
//  Wunderlist
//
//  Created by Dahna on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

enum LoginType {
    case register
    case login
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    weak var delegate: TodoListTableViewController?
    var loginType = LoginType.register
    var togglePassword: Bool = false
    let toggleButton = UIButton(type: .custom)
    let hidePasswordImage = UIImage(systemName: "eye.slash")?.withTintColor(UIColor.buttonOrange, renderingMode: .alwaysOriginal)
    let showPasswordImage = UIImage(systemName: "eye")?.withTintColor(UIColor.buttonOrange, renderingMode: .alwaysOriginal)
    
    // MARK: - Outlets
    
    @IBOutlet var loginSegControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var promptLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        let authService = AuthService()
        
        guard let user = usernameTextField.text,
            !user.isEmpty,
            let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !password.isEmpty else { return }
        authService.loginUser(with: user, password: password) {
            DispatchQueue.main.async {
                self.delegate?.updateViews()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            // sign up
            loginType = .register
            loginButton.setTitle("Register", for: .normal)
            emailTextField.isHidden = false
            promptLabel.text = "Register to Get Started"
        } else {
            // sign in
            loginType = .login
            loginButton.setTitle("Log In", for: .normal)
            emailTextField.isHidden = true
            promptLabel.text = "Please Log In"
        }
        
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
        
        toggleButton.setImage(hidePasswordImage, for: .normal)
        super.viewDidLoad()
        
        //saved dummy todo
        //        let fetchController = FetchController()
        //        let rep = TodoRepresentation(identifier: 2, completed: false, name: "do", recurring: "yeah", user_id: 1)
        //        let fetchedTodo = fetchController.fetchTodo(todoRep: rep)
        //        print(fetchedTodo?.user)
        
        configureLoginView()
        self.passwordTextField.delegate = self
    }
    
    
    private func configureLoginView() {
        
        loginButton.layer.cornerRadius = 6.0
        passwordTextField.isSecureTextEntry = true
        
        loginButton.layer.borderColor = UIColor.accentBlue.cgColor
        loginButton.layer.borderWidth = 1.0
        
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
    
        toggleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        toggleButton.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        toggleButton.addTarget(self, action: #selector(self.passwordToggled(_:)), for: .touchUpInside)
        toggleButton.accessibilityIdentifier = "toggleButton"
        passwordTextField.rightView = toggleButton
        passwordTextField.rightViewMode = .always
        
    }
    
    @ objc func passwordToggled(_: UIButton) {
        
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry == true {
            toggleButton.setImage(hidePasswordImage, for: .normal)
        } else {
            toggleButton.setImage(showPasswordImage, for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

