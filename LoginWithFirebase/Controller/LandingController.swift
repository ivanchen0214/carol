//
//  ViewController.swift
//  LoginWithFirebase
//
//  Created by chen Ivan on 2020/10/20.
//

import UIKit

class LadingController: UIViewController {
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.isNavigationBarHidden = false
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = Constants.title.landing
  }
}
