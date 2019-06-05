//
//  BadgeOptionVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/18/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import UserNotifications

class BadgeOptionVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var deniedBadgeAuthLbl: UILabel!
  var options: [BadgeOption]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setColors()
    
    options = []
    BadgeOption.allCases.forEach { (option) in
      options?.append(option)
    }
    
    deniedBadgeAuthLbl.text = "You have not approved notifications for this app. Please visit the iOS Settings app to grant authorization if you would like to have badges."
    deniedBadgeAuthLbl.numberOfLines = 4
    deniedBadgeAuthLbl.font = FontStyles.settingsCellFont
    deniedBadgeAuthLbl.textColor = ColorStyles.textColor
    deniedBadgeAuthLbl.textAlignment = .center
    
    tableView.delegate = self
    tableView.dataSource = self
    
    DispatchQueue.global(qos: .background).async {
      let center = UNUserNotificationCenter.current()
      center.getNotificationSettings { (settings) in
        if settings.authorizationStatus == .denied {
          DispatchQueue.main.async { [weak self] in
            self?.deniedBadgeAuthLbl.isHidden = false
            self?.tableView.isHidden = true
          }
        } else {
          DispatchQueue.main.async { [weak self] in
            self?.deniedBadgeAuthLbl.isHidden = true
            self?.tableView.isHidden = false
          }
        }
      }
    }
  }
  
  func setColors() {
    view.backgroundColor = ColorStyles.background
    tableView.backgroundColor = ColorStyles.background
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
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Badge number is..."
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
