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
  var dummyData: [String] = ["One", "Two", "Three"]

  override func viewDidLoad() {
    super.viewDidLoad()
    title = Constants.title.content
    navigationItem.hidesBackButton = true
    tableView.dataSource = self
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
}

extension ContentViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dummyData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "dummyCellIdentifier", for: indexPath)
    cell.textLabel?.text = dummyData[indexPath.row]
    return cell
  }
}
