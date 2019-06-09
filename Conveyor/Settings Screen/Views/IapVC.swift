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
    setColors()
  }
  
  func setColors() {
    view.backgroundColor = ColorStyles.background
    tableView.backgroundColor = ColorStyles.background
  }
  
  @IBAction func restorePressed(sender: UIBarButtonItem) {
    restoreBtn.title = "Restoring..."
    IAPStore.shared.restorePurchase {
      self.restoreBtn.title = "Restore"
      self.present(AlertFactory.purchasesRestored(), animated: true, completion: nil)
    }
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
    let cell = tableView.cellForRow(at: indexPath) as! IAPCell
    if cell.proUpgradeCell {
      performSegue(withIdentifier: Constants.SegueID.showProUserDescription.rawValue, sender: self)
    } else {
      cell.startPurchase()
      IAPStore.shared.purchaseMyProduct(index: indexPath.row) {
        cell.purchaseComplete()
      }
    }
  }
}
