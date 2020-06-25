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
    
    // MARK: - Outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var recurringSegControl: UISegmentedControl!
    @IBOutlet var datePicker: UIDatePicker!
    
    // MARK: - Actions
    @IBAction func editButtonTapped(_ sender: Any) {
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

