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
  @IBOutlet weak var copyrightLbl: UILabel!
  var settingsOptions: [Settings.SettingsListOptions]?
  var sectionHeaders: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    settingsOptions = []
    Settings.SettingsListOptions.allCases.forEach { (option) in
      settingsOptions?.append(option)
    }
    setCopyrightText()
    sectionHeaders = ["General Settings", "Info"]
  }
  
  func setCopyrightText() {
    copyrightLbl.text = """
    Conveyor 1.0
    © 2019 Drew Lanning
    All Rights Reserved
    """
  }
  
  @IBAction func doneTapped(sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
}

extension SettingsListVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionHeaders[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Settings.SettingsListOptions.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellID.settingsCell.rawValue) as! SettingsCell
    if let option = settingsOptions?[indexPath.row] {
      cell.configure(with: option.getTitle(), segueID: option.getSegueId())
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let option = settingsOptions?[indexPath.row] {
      performSegue(withIdentifier: option.getSegueId(), sender: self)
    }
  }
}
