//
//  BadgeOptionVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/18/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class BadgeOptionVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var options: [BadgeOption]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    options = []
    BadgeOption.allCases.forEach { (option) in
      options?.append(option)
    }
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func updateSettings(with option: BadgeOption) {
    Settings.defaults.set(option.rawValue, forKey: UserDefaultKeys.badgeSetting.rawValue)
    tableView.reloadData()
  }
  
}

extension BadgeOptionVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return BadgeOption.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellID.badgeOptionCell.rawValue) as! BadgeOptionCell
    if let option = options?[indexPath.row] {
      cell.configure(with: option)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let option = options?[indexPath.row] {
      updateSettings(with: option)
    }
  }
}
