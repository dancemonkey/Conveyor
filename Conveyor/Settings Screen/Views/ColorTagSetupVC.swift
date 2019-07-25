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
    setColors()
  }
  
  func setColors() {
    view.backgroundColor = ColorStyles.background
    tableView.backgroundColor = ColorStyles.background
  }
  
  @IBAction func resetAllPressed() {
    // reset all colors to original
    let confirmation = AlertFactory.confirmColorReset { [weak self] in
      Settings.resetAllColors()
      self?.tableView.reloadData()
    }
    self.present(confirmation, animated: true, completion: nil)
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
    performSegue(withIdentifier: Constants.SegueID.showColorTagSelect.rawValue, sender: indexPath)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.SegueID.showColorTagSelect.rawValue {
      let destVC = segue.destination as! ColorTagSelectVC
      destVC.colorOption = self.colors[(sender as! IndexPath).row]
      destVC.delegate = self
    }
  }
}

extension ColorTagSetupVC: ColorTagSave {
  func save(color: String, withTag tag: String) {
    Settings.setUserColor(to: (color: color, tag: tag))
    tableView?.reloadData()
  }
}
