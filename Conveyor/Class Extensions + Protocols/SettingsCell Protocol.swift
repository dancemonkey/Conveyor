//
//  File.swift
//  ToToLa
//
//  Created by Drew Lanning on 4/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

protocol SettingsCellProtocol: UITableViewCell {
  func configure()
  func setHelpText()
  func updateSettings()
  func styleViews()
}
