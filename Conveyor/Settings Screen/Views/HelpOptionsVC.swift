//
//  HelpOptionsVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/26/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

//class HelpOptionsVC: UIViewController {
//  
//  @IBOutlet weak var tableView: UITableView!
//  var options: [Settings.HelpOptionLinks]?
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    options = []
//    Settings.HelpOptionLinks.allCases.forEach { (option) in
//      options?.append(option)
//    }
//    tableView.delegate = self
//    tableView.dataSource = self
//  }
//}
//
//extension HelpOptionsVC: UITableViewDataSource, UITableViewDelegate {
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return 1
//  }
//  
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return Settings.HelpOptionLinks.allCases.count
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellID.helpOptionCell.rawValue) as! HelpOptionsListCell
//    if let option = options?[indexPath.row] {
//      cell.configure(with: option)
//    }
//    return cell
//  }
//  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    performSegue(withIdentifier: options![indexPath.row].getSegueId(), sender: self)
//  }
//}

