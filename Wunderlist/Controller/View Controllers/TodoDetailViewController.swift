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
    @IBOutlet var saveButton: UIButton!

    // MARK: - Actions
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        isEditing.toggle()
        updateViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        saveButton.layer.cornerRadius = 6.0
        //set interaction
        bodyTextView.isUserInteractionEnabled = isEditing
        saveButton.isUserInteractionEnabled = isEditing
        titleTextField.isUserInteractionEnabled = isEditing
        datePicker.isUserInteractionEnabled = isEditing
        recurringSegControl.isUserInteractionEnabled = isEditing

        //set UI
        if isEditing {
            bodyTextView.backgroundColor = .usableBlue
            saveButton.backgroundColor = .actionBlue
            titleTextField.backgroundColor = .usableBlue
            datePicker.backgroundColor = .usableBlue
            recurringSegControl.backgroundColor = .tintColor
        } else {
            bodyTextView.backgroundColor = .gray
            saveButton.backgroundColor = .gray
            titleTextField.backgroundColor = .gray
            datePicker.backgroundColor = .gray
            recurringSegControl.backgroundColor = .gray
        }

        //set Segmented Control
        if let todoRepresentation = todoRepresentation {
            title = todoRepresentation.name
            titleTextField.text = todoRepresentation.name
            bodyTextView.text = todoRepresentation.body
        }

        guard let recurring = todoRepresentation?.recurring else { return }
        guard var selectedIndex = Recurring.allCases.firstIndex(of: recurring) else { return }
        selectedIndex += 1

        recurringSegControl.selectedSegmentIndex = selectedIndex
    }

    @IBAction func updateTodo(_ sender: UIButton) {
        guard let representation = todoRepresentation,
            let todo = FetchController().fetchTodo(todoRep: representation)
        else { return }

        todo.name = titleTextField.text
        todo.body = bodyTextView.text
        todo.dueDate = datePicker.date

        var recurring: Recurring?
        if recurringSegControl.selectedSegmentIndex == 0 {
            recurring = nil
        } else {
            let selectedSegment = recurringSegControl.selectedSegmentIndex - 1
            recurring = Recurring.allCases[selectedSegment]
        }

        todo.recurring = recurring?.rawValue

        try? CoreDataStack.shared.save()
        navigationController?.popViewController(animated: true)
    }
}
