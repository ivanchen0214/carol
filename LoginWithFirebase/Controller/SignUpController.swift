//
//  SignUpController.swift
//  LoginWithFirebase
//
//  Created by chen Ivan on 2020/10/20.
//

import UIKit
import Firebase

class SignUpController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = Constants.title.signUp
  }

  @IBAction func pressSignUp(_ sender: UIButton) {
    if let email = emailTextField.text, let password = passwordTextField.text {

      Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        if error != nil {
          print(error)
        }

        self.performSegue(withIdentifier: Constants.segue.signUpToContent, sender: self)
      }
    }
  }
}
