//
//  ListController.swift
//  UseUITableViewControllerByStoryboard
//
//  Created by chen Ivan on 2020/11/14.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ListController: UITableViewController, UISearchBarDelegate {
  @IBOutlet weak var searchBar: UISearchBar!
  
  var actionType: String = ""
  let realm = try! Realm()
  var addAlert: UIAlertController?
  var editAlert: UIAlertController?
  var deleteAlert: UIAlertController?
  var itemAry: Results<Items>?
  var color: String?
  
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
    
    tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    tableView.rowHeight = 60
    
    color = UIColor.randomFlat().hexValue()
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
        
        if let currentCategory = self.selectedCategory {
          let newItem = Items()
          newItem.title = text
          newItem.selected = false
          
          let now = Date()
          let timeInterval: TimeInterval = now.timeIntervalSince1970
          let timeStamp = Int(timeInterval)
          newItem.createdDate = String(timeStamp)
          
          self.addData(withCategory: currentCategory, withItem: newItem)
        }
        
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
  
  func loadData() {
    itemAry = selectedCategory?.items.sorted(byKeyPath: "createdDate", ascending: true)
    tableView.reloadData()
  }
  
  func addData(withCategory category: Categories, withItem item: Items) {
    do {
      try realm.write {
        category.items.append(item)
      }
    } catch {
      print("Error saving context \(error)")
    }
  }
  
  func saveData(exec: () -> Void) {
    do {
      try realm.write {
        exec()
      }
    } catch {
      print("Error saving context \(error)")
    }
  }
  
  //MARK: delete data
  func deleteData(_ item: Items) {
    do {
      try realm.write {
        realm.delete(item)
      }
    } catch {
      print("Error saving context \(error)")
    }
  }
}

//MARK: UITableViewController
extension ListController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemAry?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! SwipeTableViewCell
    
    if let item = itemAry?[indexPath.row] {
      let createDate: Date = Date(timeIntervalSince1970: Double(item.createdDate!)!)
      let dformatter = DateFormatter()
      let cellColor = UIColor(hexString: self.color ?? "#d0f0c0")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(self.itemAry!.count))

      dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      cell.textLabel?.numberOfLines = 0
      
      cell.backgroundColor = cellColor!
      cell.textLabel?.textColor = ContrastColorOf(cellColor!, returnFlat: true)
      cell.textLabel?.text = "[\(dformatter.string(from: createDate))] \n \(item.title)"
      
      if !item.selected {
        cell.accessoryType = UITableViewCell.AccessoryType.none
      } else {
        cell.accessoryType = UITableViewCell.AccessoryType.checkmark
      }
    }
    
    cell.delegate = self
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = itemAry?[indexPath.row] {
      self.saveData {
        item.selected = !item.selected
      }
    }
    
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

//MARK: SwipeTableView
extension ListController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
      self.actionType = "EDIT"
      self.editAlert = UIAlertController(title: "Edit", message: "", preferredStyle: UIAlertController.Style.alert)
      
      self.editAlert?.addTextField { (alertTextField) in
        alertTextField.keyboardType = UIKeyboardType.default
        alertTextField.returnKeyType = UIReturnKeyType.go
        alertTextField.placeholder = "something..."
        alertTextField.text = self.itemAry?[indexPath.row].title
        alertTextField.addTarget(self, action: #selector(ListController.alertTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
      }
      
      let editBtn = UIAlertAction(title: "Edit", style: UIAlertAction.Style.default) { (UIAlertAction) in
        let textField = self.editAlert?.textFields![0]
        
        if let text = textField?.text, let item = self.itemAry?[indexPath.row] {
          textField?.resignFirstResponder()
          
          self.saveData {
            item.title = text
          }
          
          tableView.reloadData()
        }
      }
      
      let cancelBtn = UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel) { (UIAlertAction) in
        self.editAlert?.dismiss(animated: true, completion: nil)
      }
      
      self.editAlert?.addAction(editBtn)
      self.editAlert?.addAction(cancelBtn)
      self.present(self.editAlert!, animated: true, completion: nil)
    }
    editAction.backgroundColor = UIColor.blue
    editAction.image = UIImage(systemName: "pencil")
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      self.actionType = "DELETE"
      self.deleteAlert = UIAlertController(title: "Delete", message: self.itemAry?[indexPath.row].title, preferredStyle: UIAlertController.Style.alert)
      
      let deleteBtn = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (UIAlertAction) in
        self.deleteData((self.itemAry?[indexPath.row])!)
        tableView.reloadData()
      }
      
      let cancelBtn = UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel) { (UIAlertAction) in
        self.deleteAlert?.dismiss(animated: true, completion: nil)
      }
      
      self.deleteAlert?.addAction(deleteBtn)
      self.deleteAlert?.addAction(cancelBtn)
      self.present(self.deleteAlert!, animated: true, completion: nil)
    }
    deleteAction.backgroundColor = UIColor.red
    deleteAction.image = UIImage(systemName: "trash")
    
    return [deleteAction, editAction]
  }
}

//MARK: UISearchBar
extension ListController {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count == 0 {
      loadData()
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    } else {
      itemAry = itemAry?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "title", ascending: true)
      tableView.reloadData()
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  }
}
