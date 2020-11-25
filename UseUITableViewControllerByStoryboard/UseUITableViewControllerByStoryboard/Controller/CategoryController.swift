//
//  CategoryController.swift
//  UseUITableViewControllerByStoryboard
//
//  Created by chen Ivan on 2020/11/18.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let realm = try! Realm()
  var addAlert: UIAlertController?
  var deleteAlert: UIAlertController?
  var categoryAry: Results<Categories>?
  var cellColorAry: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Category"
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    tableView.rowHeight = 60
    
    loadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist") }
    
    navBar.prefersLargeTitles = true
    navBar.sizeToFit()
    navBar.backgroundColor = UIColor.blue
    navBar.barTintColor = UIColor.white
    navBar.tintColor = UIColor.white
    navBar.largeTitleTextAttributes = [NSMutableAttributedString.Key.foregroundColor: UIColor.white]
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
        
        let newCategory = Categories()
        newCategory.title = text
        
        self.saveData(newCategory)
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
  
  func loadData() {
    categoryAry = realm.objects(Categories.self)
    cellColorAry.removeAll()
    tableView.reloadData()
  }
  
  func saveData(_ category: Categories) {
    do {
      try realm.write {
        realm.add(category)
        self.cellColorAry.removeAll()
      }
    } catch {
      print("Error saving context \(error)")
    }
  }
  
  func deleteData(_ category: Categories) {
    do {
      try realm.write {
        let itemAry: Results<Items>?
        itemAry = category.items.sorted(byKeyPath: "title", ascending: true)
        
        if itemAry!.count != 0 {
          realm.delete(itemAry!)
        }
        
        realm.delete(category)
        self.cellColorAry.removeAll()
      }
    } catch {
      print("Error saving context \(error)")
    }
  }
}

//MARK: UITableView
extension CategoryController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryAry?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellColor = UIColor.randomFlat()
    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
    cell.backgroundColor = cellColor
    cell.textLabel?.text = self.categoryAry?[indexPath.row].title
    cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
    cell.delegate = self
    
    cellColorAry.append(cellColor.hexValue())
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "gotoList", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ListController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categoryAry?[indexPath.row]
      destinationVC.cellColor = cellColorAry[indexPath.row]
    }
  }
}

//MARK: SwipeTableView
extension CategoryController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      self.deleteAlert = UIAlertController(title: "Delete", message: self.categoryAry?[indexPath.row].title, preferredStyle: UIAlertController.Style.alert)
      
      let deleteBtn = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (UIAlertAction) in
        self.deleteData((self.categoryAry?[indexPath.row])!)
        tableView.reloadData()
      }
      
      let cancelBtn = UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel) { (UIAlertAction) in
        self.deleteAlert?.dismiss(animated: true, completion: nil)
      }
      
      self.deleteAlert?.addAction(deleteBtn)
      self.deleteAlert?.addAction(cancelBtn)
      self.present(self.deleteAlert!, animated: true, completion: nil)
    }
    deleteAction.image = UIImage(systemName: "trash")
    
    return [deleteAction]
  }
  
}
