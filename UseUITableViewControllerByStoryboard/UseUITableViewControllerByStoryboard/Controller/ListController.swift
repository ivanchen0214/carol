//
//  ListController.swift
//  UseUITableViewControllerByStoryboard
//
//  Created by chen Ivan on 2020/11/14.
//

// Core Data Path: /Library/Developer/CoreSimulator/Devices/B68B6F20-A1B2-4625-AFF2-263A5BA1C87D/data/Containers/Data/Application/7BA5A189-E6AD-43E3-BD21-B241C9779AA1/Library/Application Support

import UIKit

class ListController: UITableViewController, UISearchBarDelegate {
  @IBOutlet weak var searchBar: UISearchBar!
  
  var actionType: String = ""
  var addAlert: UIAlertController?
  var editAlert: UIAlertController?
  var deleteAlert: UIAlertController?
  var itemAry = [Items]()
  
  var selectedCategory: Categories? {
    didSet {
      loadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // print(dataFilePath)
    UINavigationBar.appearance().barTintColor = UIColor.blue
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
    navigationItem.title = "List"
    
    searchBar.delegate = self
    searchBar.autocapitalizationType = UITextAutocapitalizationType.none
  }
  
  @IBAction func pressBackBtn(_ sender: UIBarButtonItem) {
    // dismiss will back to root page
    // self.dismiss(animated: true, completion: nil)
    
    // pop will back to previous page
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func pressAddBtn(_ sender: UIBarButtonItem) {
    actionType = "ADD"
    addAlert = UIAlertController(title: "Add A New Item", message: "", preferredStyle: UIAlertController.Style.alert)
    addAlert?.addTextField { (alertTextField) in
      alertTextField.keyboardType = UIKeyboardType.default
      alertTextField.returnKeyType = UIReturnKeyType.go
      alertTextField.placeholder = "something..."
      alertTextField.addTarget(self, action: #selector(ListController.alertTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    let addAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { (UIAlertAction) in
      let textField = self.addAlert?.textFields![0]
      
      if let text = textField?.text {
        textField?.resignFirstResponder()
        
        self.saveData()
        
        self.tableView.reloadData()
      }
    }
    addAction.isEnabled = false
    
    let cancelAction = UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel) { (UIAlertAction) in
      self.addAlert?.dismiss(animated: true, completion: nil)
    }
    
    addAlert?.addAction(addAction)
    addAlert?.addAction(cancelAction)
    present(addAlert!, animated: true, completion: nil)
  }
  
  @objc func alertTextFieldDidChange(_ sender: UITextField) {
    if actionType == "ADD" {
      addAlert?.actions[0].isEnabled = sender.text!.count > 0
    }
    
    if actionType == "EDIT" {
      editAlert?.actions[0].isEnabled = sender.text!.count > 0
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemAry.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
    cell.textLabel?.text = self.itemAry[indexPath.row].title
    
    if !itemAry[indexPath.row].selected {
      cell.accessoryType = UITableViewCell.AccessoryType.none
    } else {
      cell.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    itemAry[indexPath.row].selected = !itemAry[indexPath.row].selected
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //- Editing cell, one button
  //  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  //    deleteAlert = UIAlertController(title: "Delete this one?", message: "", preferredStyle: UIAlertController.Style.alert)
  //    deleteAlert?.message = itemAry[indexPath.row].title
  //
  //    let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (UIAlertAction) in
  //      self.context.delete(self.itemAry[indexPath.row])
  //      self.itemAry.remove(at: indexPath.row)
  //
  //      do {
  //        try self.context.save()
  //      } catch {
  //        print("Error saving context \(error)")
  //      }
  //
  //      tableView.reloadData()
  //    }
  //
  //    let cancelAction = UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel) { (UIAlertAction) in
  //      self.deleteAlert?.dismiss(animated: true, completion: nil)
  //    }
  //
  //    deleteAlert?.addAction(deleteAction)
  //    deleteAlert?.addAction(cancelAction)
  //    present(deleteAlert!, animated: true, completion: nil)
  //  }
  //
  //  override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
  //    return "Delete"
  //  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let editAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Edit") { (action, view, completionHandler) in
      self.actionType = "EDIT"
      self.editAlert = UIAlertController(title: "Edit", message: "", preferredStyle: UIAlertController.Style.alert)
      
      self.editAlert?.addTextField { (alertTextField) in
        alertTextField.keyboardType = UIKeyboardType.default
        alertTextField.returnKeyType = UIReturnKeyType.go
        alertTextField.placeholder = "something..."
        alertTextField.text = self.itemAry[indexPath.row].title
        alertTextField.addTarget(self, action: #selector(ListController.alertTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
      }
      
      let editAction = UIAlertAction(title: "Edit", style: UIAlertAction.Style.default) { (UIAlertAction) in
        let textField = self.editAlert?.textFields![0]
        
        if let text = textField?.text {
          textField?.resignFirstResponder()
          self.itemAry[indexPath.row].setValue(text, forKey: "title")
          self.saveData()
          
          tableView.reloadData()
        }
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel) { (UIAlertAction) in
        self.editAlert?.dismiss(animated: true, completion: nil)
      }
      
      self.editAlert?.addAction(editAction)
      self.editAlert?.addAction(cancelAction)
      self.present(self.editAlert!, animated: true, completion: nil)
      
      completionHandler(true)
    }
    editAction.backgroundColor = UIColor.blue
    
    let deleteAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Delete") { (action, view, completionHandler) in
      self.actionType = "DELETE"
      self.deleteAlert = UIAlertController(title: "Delete", message: self.itemAry[indexPath.row].title, preferredStyle: UIAlertController.Style.alert)
      
      let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (UIAlertAction) in
        self.itemAry.remove(at: indexPath.row)
        self.saveData()
        
        tableView.reloadData()
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel) { (UIAlertAction) in
        self.deleteAlert?.dismiss(animated: true, completion: nil)
      }
      
      self.deleteAlert?.addAction(deleteAction)
      self.deleteAlert?.addAction(cancelAction)
      self.present(self.deleteAlert!, animated: true, completion: nil)
      
      completionHandler(true)
    }
    deleteAction.backgroundColor = UIColor.red
    
    return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
  }
  
  //MARK: load data
  func loadData() {
    do {
      tableView.reloadData()
    } catch {
      print("Error fetch data from context \(error)")
    }
  }
  
  //MARK: save data
  func saveData() {
    do {
    } catch {
      print("Error saving context \(error)")
    }
  }
}

extension ListController {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count == 0 {
      loadData()
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    } else {
      /*
      let request: NSFetchRequest<Items> = Items.fetchRequest()
      let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
      request.predicate = predicate
      
      loadData(request)
      */
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  }
}
