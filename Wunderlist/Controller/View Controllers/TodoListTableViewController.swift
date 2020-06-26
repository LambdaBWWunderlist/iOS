//
//  TodoListTableViewController.swift
//  Wunderlist
//
//  Created by Kenny on 6/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {
    // MARK: Properties
    let toDoController = TodoController()

    @IBOutlet private var searchBar: UISearchBar!

    private let detailSegueID = "TodoDetailSegue"
    private let addTodoSegue = "AddTodoSegue"

    lazy var fetchedResultsController: NSFetchedResultsController<Todo> = {

        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "recurring",
                             ascending: true),
            NSSortDescriptor(key: "dueDate",
                                        ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "username == %@", AuthService.activeUser!.username)

        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "recurring",
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let frcError {
            NSLog(
                """
                Error fetching data from frc: \(#file), \(#function), \(#line) -
                \(frcError)
                """)
        }
        return frc
    }()

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - TableView DataSource -
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].objects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseID, for: indexPath) as? TodoTableViewCell else { return UITableViewCell() }
        let todo = fetchedResultsController.object(at: indexPath)
        cell.todoRep = todo.todoRepresentation
        cell.todoController = toDoController
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        return sectionInfo.name.capitalized
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let todoRep = fetchedResultsController.object(at: indexPath).todoRepresentation else { return }
            toDoController.deleteTodo(representation: todoRep)
        }
    }

    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueID {
            guard let destination = segue.destination as? TodoDetailViewController else { return }

            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let todo = fetchedResultsController.object(at: indexPath)
            destination.todoRepresentation = todo.todoRepresentation
            destination.todoController = toDoController

        } else if segue.identifier == addTodoSegue {
            guard let destination = segue.destination as? CreateTodoViewController else { return }
            destination.todoController = toDoController

        }
    }

    // MARK: - Functions

    func updateViews() {
          let todoController = TodoController()
        guard AuthService.activeUser != nil else { return }
          todoController.fetchTodosFromServer { _ in
            try? self.fetchedResultsController.performFetch()
            DispatchQueue.main.async {
              self.tableView.reloadData()
          }
        }
      }
    }

// MARK: - CoreData Delegate Methods -
extension TodoListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension TodoListTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard let username = AuthService.activeUser?.username else { return }
        var predicate: NSPredicate?
        if searchBar.text?.count != 0 {
            predicate = NSPredicate(format: "(name CONTAINS[cd] %@) || (recurring CONTAINS[cd] %@ && username == %@)", searchText, searchText, username)
        } else {
            predicate = NSPredicate(format: "username == %@", AuthService.activeUser!.username)
        }

        fetchedResultsController.fetchRequest.predicate = predicate

        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            NSLog("Error performing fetch: \(error)")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "username == %@", AuthService.activeUser!.username)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Error: \(error)")
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
    }
}
