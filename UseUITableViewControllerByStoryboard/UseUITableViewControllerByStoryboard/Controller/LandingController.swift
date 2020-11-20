//
//  ViewController.swift
//  UseUITableViewControllerByStoryboard
//
//  Created by chen Ivan on 2020/11/14.
//

import UIKit

class LandingController: UIViewController {
  
  @IBOutlet weak var iconImageView: UIImageView!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    iconImageView.contentMode = UIView.ContentMode.scaleAspectFit
    iconImageView.layer.cornerRadius = 60
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LandingController.imageTapped(gesture:)))
    iconImageView.addGestureRecognizer(tapGesture)
    iconImageView.isUserInteractionEnabled = true
  }
  
  @objc func imageTapped(gesture: UIGestureRecognizer) {
    if (gesture.view as? UIImageView) != nil {
      self.performSegue(withIdentifier: "gotoCategory", sender: self)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    let destinationVC = segue.destination as! ResultViewController
//    destinationVC.bmiCalc = "0.0"
  }
}

