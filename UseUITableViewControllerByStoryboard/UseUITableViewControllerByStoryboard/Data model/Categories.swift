//
//  Categories.swift
//  UseUITableViewControllerByStoryboard
//
//  Created by chen Ivan on 2020/11/21.
//

import Foundation
import RealmSwift

class Categories: Object {
  @objc dynamic var title: String = ""
  let items = List<Items>()
}
