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
    var todoRepresentation: TodoRepresentation?
    
    // MARK: - Outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var recurringSegControl: UISegmentedControl!
    @IBOutlet var bodyTextView: UILabel!
    
    
    // MARK: - Actions
    @IBOutlet var saveButtonTapped: UIBarButtonItem!
   
    //    When we call "PostToDo", we should only pass in a representation that is currently being initialized in CoreData (Todo.representation)

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        guard let todoRep = todoRepresentation else { return }
        title = todoRep.name
        titleTextField.text = todoRep.name
        bodyTextView.text = todoRep.body
    }

}
