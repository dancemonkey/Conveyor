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
  var generalOptions: [Settings.GeneralSettingsOptions]?
  var infoOptions: [Settings.InfoSettingsOptions]?
  var sectionHeaders: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    populateSettingsInfo()
    setCopyrightText()
  }
  
  func populateSettingsInfo() {
    sectionHeaders = ["General Settings", "Info"]
    generalOptions = []
    infoOptions = []
    Settings.GeneralSettingsOptions.allCases.forEach { (option) in
      generalOptions?.append(option)
    }
    Settings.InfoSettingsOptions.allCases.forEach { (option) in
      infoOptions?.append(option)
    }
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
    return 2
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionHeaders[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return Settings.GeneralSettingsOptions.allCases.count
    case 1:
      return Settings.InfoSettingsOptions.allCases.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellID.settingsCell.rawValue) as! SettingsCell
    switch indexPath.section {
    case 0:
      if let option = generalOptions?[indexPath.row] {
        cell.configure(with: option.getTitle(), segueID: option.getSegueId())
      }
    case 1:
      if let option = infoOptions?[indexPath.row] {
        cell.configure(with: option.getTitle(), segueID: option.getSegueId())
      }
    default:
      return cell
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      if let option = generalOptions?[indexPath.row] {
        performSegue(withIdentifier: option.getSegueId(), sender: self)
      }
    case 1:
      if let option = infoOptions?[indexPath.row] {
        performSegue(withIdentifier: option.getSegueId(), sender: self)
      }
    default:
      print("You may ask yourself how did I get here?")
    }
    
  }
}
