//
//  ContentTableViewCell.swift
//  LoginWithFirebase
//
//  Created by chen Ivan on 2020/10/22.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var itemLabel: UILabel!
  @IBOutlet weak var itemView: UIView!
  @IBOutlet weak var itemBtnView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
//    itemView.layer.cornerRadius = itemView.frame.size.height / 5
//    itemBtnView.layer.cornerRadius = itemBtnView.frame.size.height / 5
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
