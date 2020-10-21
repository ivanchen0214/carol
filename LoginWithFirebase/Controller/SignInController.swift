//
//  SignInController.swift
//  LoginWithFirebase
//
//  Created by chen Ivan on 2020/10/20.
//

import UIKit
import Firebase

class SignInController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Sign In"
  }

  @IBAction func pressSignUp(_ sender: UIButton) {
    if let email = emailTextField.text, let password = passwordTextField.text {
      Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        if error != nil {
          print(error)
        }

        self.performSegue(withIdentifier: "signInToContent", sender: self)
      }
    }
  }
}
