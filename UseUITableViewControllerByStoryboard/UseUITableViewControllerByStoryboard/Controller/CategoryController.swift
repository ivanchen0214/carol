//
//  CategoryController.swift
//  UseUITableViewControllerByStoryboard
//
//  Created by chen Ivan on 2020/11/18.
//

import UIKit
import CoreData

class CategoryController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let request: NSFetchRequest<Items> = Items.fetchRequest()
  var addAlert: UIAlertController?
  var deleteAlert: UIAlertController?

  var categoryAry = [Categories]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UINavigationBar.appearance().barTintColor = UIColor.blue
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
    navigationItem.title = "Category"
    
    tableView.delegate = self
    tableView.dataSource = self
    
    loadData()
  }
  
  @IBAction func pressAddBtn(_ sender: UIBarButtonItem) {
    addAlert = UIAlertController(title: "Add A New Category", message: "", preferredStyle: UIAlertController.Style.alert)
    addAlert?.addTextField { (alertTextField) in
      alertTextField.keyboardType = UIKeyboardType.default
      alertTextField.returnKeyType = UIReturnKeyType.go
      alertTextField.placeholder = "something..."
      alertTextField.addTarget(self, action: #selector(CategoryController.alertTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    let addAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { (UIAlertAction) in
      let textField = self.addAlert?.textFields![0]
      
      if let text = textField?.text {
        textField?.resignFirstResponder()
        let newCategory = Categories(context: self.context)
        newCategory.title = text
        self.categoryAry.append(newCategory)
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
    addAlert?.actions[0].isEnabled = sender.text!.count > 0
  }
  
  //MARK: load data
  func loadData(_ request: NSFetchRequest<Categories> = Categories.fetchRequest()) {
    do {
      categoryAry = try context.fetch(request)
      tableView.reloadData()
    } catch {
      print("Error fetch data from context \(error)")
    }
  }
  
  //MARK: save data
  func saveData() {
    do {
      try self.context.save()
    } catch {
      print("Error saving context \(error)")
    }
  }
}

extension CategoryController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryAry.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as UITableViewCell
    cell.textLabel?.text = self.categoryAry[indexPath.row].title
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Delete") { (action, view, completionHandler) in
      self.deleteAlert = UIAlertController(title: "Delete", message: self.categoryAry[indexPath.row].title, preferredStyle: UIAlertController.Style.alert)
      
      let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (UIAlertAction) in
        self.context.delete(self.categoryAry[indexPath.row])
        self.categoryAry.remove(at: indexPath.row)
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
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "gotoList", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ListController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categoryAry[indexPath.row]
    }
  }
}
