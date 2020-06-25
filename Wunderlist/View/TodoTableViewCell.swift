//
//  TodoTableViewCell.swift
//  Wunderlist
//
//  Created by Dahna on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    // MARK: - Properties -
    static let reuseID = "TodoCell"

    var todoController: TodoController?
    var todoRep: TodoRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets -
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var completeToggleButton: UIButton!

    func updateViews() {
        guard let todoRep = todoRep else { return }
        titleLabel.text = todoRep.name
        todoRep.completed ?? false ? completeToggleButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) : completeToggleButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }    
    
    // MARK: - Actions -
    @IBAction func completeToggleTapped(_ sender: Any) {
        guard let todoRep = todoRep,
            let todo = todoController?.fetchController.fetchTodo(todoRep: todoRep)
        else { return }
        self.todoRep?.completed?.toggle()
        todo.completed.toggle()
        updateViews()
        do {
            try CoreDataStack.shared.save()
        } catch let saveError {
            print("error saving todo after toggling save: \(saveError)")
        }
        //TODO: send to server
    }

}
