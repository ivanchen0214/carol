//
//  ListController.swift
//  UseUITableViewControllerByStoryboard
//
//  Created by chen Ivan on 2020/11/14.
//

import UIKit

class ListController: UITableViewController {
  
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
}
