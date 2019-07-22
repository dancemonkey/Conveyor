//
//  ColorTagSetupVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 7/22/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ColorTagSetupVC: UIViewController {
  
  var colors = [ColorOption]()
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setColors()
    for color in ColorOption.allCases {
      colors.append(color)
    }
    tableView.delegate = self
    tableView.dataSource = self
    if IAPStore().isProUser() {
      tableView.isUserInteractionEnabled = true
      tableView.alpha = 1.0
    } else {
      tableView.isUserInteractionEnabled = false
      tableView.alpha = 0.5
    }
  }
  
  func setColors() {
    view.backgroundColor = ColorStyles.background
    tableView.backgroundColor = ColorStyles.background
  }
  
}

extension ColorTagSetupVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ColorOption.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellID.colorOptionCell.rawValue) as? ColorTagSettingCell else { return UITableViewCell() }
    cell.configure(with: colors[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // segue to color selection screen
    // set delegate to save color selection
  }
}
