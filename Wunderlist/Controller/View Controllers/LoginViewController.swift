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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
