//
//  CreateTodoViewController.swift
//  Wunderlist
//
//  Created by Dahna on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import UserNotifications

class CreateTodoViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties -
    var todoController: TodoController?
    let notificationController = NotificationController()

    // MARK: - Outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var recurringSegControl: UISegmentedControl!
    @IBOutlet var bodyTextView: UITextView!
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

        let recurring: Recurring?
        if recurringSegControl.selectedSegmentIndex == 0 {
            recurring = nil
        } else {
            let selectedSegment = recurringSegControl.selectedSegmentIndex - 1
            recurring = Recurring.allCases[selectedSegment]
        }

        let representation = TodoRepresentation(identifier: nil, completed: false, name: name, body: bodyTextView.text, recurring: recurring, username: nil, userID: AuthService.activeUser?.identifier ?? 0, dueDate: datePicker.date)
        print("Error: \(String(describing: bodyTextView.text))")
        todoController?.createTodo(representation: representation, date: datePicker.date) {

            DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            }
        }
    }

    //When we call "PostToDo", we should only pass in a representation that is currently being initialized in CoreData (Todo.representation)

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
         self.notificationController.requestNotificationAuthorization()
    }

    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
