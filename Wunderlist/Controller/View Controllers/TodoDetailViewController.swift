//
//  TodoDetailViewController.swift
//  Wunderlist
//
//  Created by Kenny on 6/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class TodoDetailViewController: UIViewController {

    // MARK: - Properties -
    var todoRepresentation: TodoRepresentation?
    var todoController: TodoController?
    var todo: Todo?
    
    // MARK: - Outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var recurringSegControl: UISegmentedControl!
    
    // MARK: - Actions
    @IBAction func editButtonTapped(_ sender: Any) {
        guard let name = titleTextField.text,
            titleTextField.text != nil else {
                let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: .none)
                let alert = UIAlertController(title: "This ToDo Needs A Name!",
                                              message: "Dismiss this message to enter a name for your ToDo",
                                              preferredStyle: .alert)
                alert.addAction(dismissAction)
                self.present(alert, animated: true)
                return }
        let representation = TodoRepresentation(identifier: nil, completed: false, name: name, body: bodyTextView.text, recurring: "Daily", username: AuthService.activeUser?.username ?? "", dueDate: Date())
        todoController?.updateTodoRep(todo: todo!, with: representation)
//        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: .none)
//        let alert = UIAlertController(title: "This ToDo Needs A Name!",
//                                      message: "Dismiss this message to enter a name for your ToDo",
//                                      preferredStyle: .alert)
//        alert.addAction(dismissAction)
//              self.present(alert, animated: true)
        navigationController?.popViewController(animated: true)
  
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        if let todoRepresentation = todoRepresentation {
            titleTextField.text = todoRepresentation.name
            bodyTextView.text = todoRepresentation.body
        } else {

        }
    }

}

