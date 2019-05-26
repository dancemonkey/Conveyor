//
//  IapVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 5/25/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class IapVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var restoreBtn: UIBarButtonItem!
  @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    activitySpinner.startAnimating()
    IAPStore.shared.fetchAvailableProducts { [weak self] in
      self?.tableView.reloadData()
      self?.activitySpinner.stopAnimating()
    }
    // Do any additional setup after loading the view.
  }
  
  @IBAction func restorePressed(sender: UIBarButtonItem) {
    print("restoring purchases")
    IAPStore.shared.restorePurchase()
  }
}

extension IapVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return IAPStore.shared.iapProducts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellID.iapCell.rawValue) as! IAPCell
    cell.configure(with: IAPStore.shared.iapProducts[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    IAPStore.shared.purchaseMyProduct(index: indexPath.row)
  }
}
