//
//  SettingsListVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/17/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class SettingsListVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var settingsOptions: [Settings.SettingsListOptions]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    settingsOptions = []
    Settings.SettingsListOptions.allCases.forEach { (option) in
      settingsOptions?.append(option)
    }
  }
  
}

extension SettingsListVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Settings.SettingsListOptions.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! SettingsCell
    if let option = settingsOptions?[indexPath.row] {
      cell.configure(with: option.getTitle(), segueID: option.getSegueId())
    } else {
      cell.configure(with: "No Title", segueID: "oops")
    }
    return cell
  }
  
}
