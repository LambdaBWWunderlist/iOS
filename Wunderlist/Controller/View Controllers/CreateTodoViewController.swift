//
//  CreateTodoViewController.swift
//  Wunderlist
//
//  Created by Dahna on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class CreateTodoViewController: UIViewController {

    // MARK: - Properties -
    var todoController: TodoController?
    
    // MARK: - Outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var recurringSegControl: UISegmentedControl!
    @IBOutlet var bodyTextView: UILabel!
    
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = titleTextField.text else {
            print("The Todo needs a name!")
            return
        }
        #warning("update recurring string")
        #warning("update with date from datePicker")
        let representation = TodoRepresentation(identifier: nil, completed: false, name: name, body: bodyTextView.text, recurring: "daily", username: nil, userID: AuthService.activeUser?.identifier ?? 0, dueDate: Date())
        todoController?.createTodo(representation: representation)
    }
   
    //    When we call "PostToDo", we should only pass in a representation that is currently being initialized in CoreData (Todo.representation)

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        
    }

}
