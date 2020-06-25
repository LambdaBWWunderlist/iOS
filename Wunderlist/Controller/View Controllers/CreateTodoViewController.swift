//
//  CreateTodoViewController.swift
//  Wunderlist
//
//  Created by Dahna on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class CreateTodoViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties -
    var todoController: TodoController?
    
    // MARK: - Outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var recurringSegControl: UISegmentedControl!
    @IBOutlet var bodyTextView: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = titleTextField.text,
            !name.isEmpty  else {
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: .none)
            let alert = UIAlertController(title: "This ToDo Needs A Name!",
                                          message: "Dismiss this message to enter a name for your ToDo",
                                          preferredStyle: .alert)
            alert.addAction(dismissAction)
            self.present(alert, animated: true)
            return
        }
        #warning("update with date from datePicker")
        let representation = TodoRepresentation(identifier: nil, completed: false, name: name, body: bodyTextView.text, recurring: Recurring.allCases[recurringSegControl.selectedSegmentIndex], username: nil, userID: AuthService.activeUser?.identifier ?? 0, dueDate: Date())
        todoController?.createTodo(representation: representation)
    }
   
    //    When we call "PostToDo", we should only pass in a representation that is currently being initialized in CoreData (Todo.representation)

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        titleTextField.delegate = self
    }

    private func updateViews() {
        
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
