//
//  CompletedItemsOptionVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/18/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class CompletedItemsOptionVC: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var options: [DoneOption]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    options = []
    DoneOption.allCases.forEach { (option) in
      options?.append(option)
    }
    tableView.delegate = self
    tableView.dataSource = self
    setColors()
  }
  
  func updateSettings(with option: DoneOption) {
    Settings.defaults.set(option.rawValue, forKey: UserDefaultKeys.doneSetting.rawValue)
    tableView.reloadData()
  }
  
  func setColors() {
    view.backgroundColor = ColorStyles.background
    tableView.backgroundColor = ColorStyles.background
  }
}

extension CompletedItemsOptionVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return #"Completed task defaults"#
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DoneOption.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellID.doneOptionCell.rawValue) as! DoneOptionCell
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
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.lightGray
  }
}

