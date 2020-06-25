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
    @IBOutlet var datePicker: UIDatePicker!
    
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        //  When we call "PostToDo", we should only pass in a representation that is currently being initialized in CoreData (Todo.representation)
        
        self.dismiss(animated: true, completion: nil)
//        self.dateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        
    }
    
   
}
