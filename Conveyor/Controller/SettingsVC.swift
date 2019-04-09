//
//  SettingsVC.swift
//  ToToLa
//
//  Created by Drew Lanning on 4/1/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
  
  @IBOutlet var settingsContainer: UIView!
  @IBOutlet weak var doneBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addHeading()
    applyGlobalStyles()
  }
  
  func applyGlobalStyles() {
    self.view.backgroundColor = ColorStyles.backgroundWhite
    doneBtn.layer.cornerRadius = 4.0
  }
  
  private func addHeading() {
    let titleLabel = UILabel()
    titleLabel.text = "Settings"
    titleLabel.textColor = ColorStyles.blackText
    titleLabel.font = FontStyles.mainTitleFont
    titleLabel.textAlignment = .right
    titleLabel.adjustsFontSizeToFitWidth = true
    self.view.addSubview(titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    let views: [String: Any] = ["label": titleLabel]
    let hFormat = "[label]-16-|"
    let vFormat = "V:|-55-[label(30@1000)]"
    let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: [], metrics: nil, views: views)
    let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: nil, views: views)
    var allConstraints: [NSLayoutConstraint] = []
    allConstraints = allConstraints + hConstraints
    allConstraints = allConstraints + vConstraints
    NSLayoutConstraint.activate(allConstraints)
  }
  
  @IBAction func doneTapped(sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
}
