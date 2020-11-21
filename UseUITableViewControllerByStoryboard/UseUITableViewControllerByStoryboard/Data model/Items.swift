//
//  Items.swift
//  UseUITableViewControllerByStoryboard
//
//  Created by chen Ivan on 2020/11/21.
//

import Foundation
import RealmSwift

class Items: Object {
  @objc dynamic var title: String = ""
  @objc dynamic var selected: Bool = false
  var parentCategories = LinkingObjects(fromType: Categories.self, property: "items")
}
