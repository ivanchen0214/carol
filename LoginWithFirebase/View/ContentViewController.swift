//
//  ContentViewController.swift
//  LoginWithFirebase
//
//  Created by chen Ivan on 2020/10/21.
//

import UIKit
import Firebase

class ContentViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var itemTextField: UITextField!
  
  var dummyData: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.register(UINib(nibName: Constants.xib.content, bundle: nil), forCellReuseIdentifier: Constants.cell.content)
    itemTextField.delegate = self
    
    title = Constants.title.content
    navigationItem.hidesBackButton = true
  }
  
  @IBAction func pressLogout(_ sender: UIBarButtonItem) {
    let firebaseAuth = Auth.auth()
    
    do {
      try firebaseAuth.signOut()
      navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
  }
  
  @IBAction func pressAddItem(_ sender: UIButton) {
    if let newItem = itemTextField.text, !newItem.isEmpty {
      dummyData.append(newItem)
      tableView.reloadData()
    }
  }
}

extension ContentViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dummyData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell.content, for: indexPath) as! ContentTableViewCell
    cell.itemLabel.text = dummyData[indexPath.row]
    return cell
  }
}

extension ContentViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
