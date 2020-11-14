//
//  ListController.swift
//  UseUITableViewControllerByStoryboard
//
//  Created by chen Ivan on 2020/11/14.
//

import UIKit

class ListController: UITableViewController {
  var alert: UIAlertController = UIAlertController(title: "Add A New Item", message: "", preferredStyle: UIAlertController.Style.alert)
  var itemAry = [Item]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UINavigationBar.appearance().barTintColor = UIColor.blue
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
    navigationItem.title = "List"
  }
  
  @IBAction func pressBackBtn(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func pressAddBtn(_ sender: UIBarButtonItem) {
    alert = UIAlertController(title: "Add A New Item", message: "", preferredStyle: UIAlertController.Style.alert)
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "something..."
      alertTextField.addTarget(self, action: #selector(ListController.alertTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }

    let addAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { (UIAlertAction) in
      let textField = self.alert.textFields![0]
      
      if let text = textField.text {
        let newItem = Item()
        newItem.title = text
        newItem.selected = false
        self.itemAry.append(newItem)
        self.tableView.reloadData()
      }
    }
    addAction.isEnabled = false
    
    let cancelAction = UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel) { (UIAlertAction) in
      self.alert.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(addAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  @objc func alertTextFieldDidChange(_ sender: UITextField) {
    alert.actions[0].isEnabled = sender.text!.count > 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemAry.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
    cell.textLabel?.text = self.itemAry[indexPath.row].title
    
    return cell
  }
}
