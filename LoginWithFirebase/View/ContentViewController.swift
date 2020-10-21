//
//  ContentViewController.swift
//  LoginWithFirebase
//
//  Created by chen Ivan on 2020/10/21.
//

import UIKit
import Firebase

class ContentViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Content"
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
}
