//
//  SettingsTVC.swift
//  ToToLa
//
//  Created by Drew Lanning on 4/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }
}
