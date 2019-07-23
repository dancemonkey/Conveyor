//
//  ColorTagSaveProtocol.swift
//  Conveyor
//
//  Created by Drew Lanning on 7/23/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

protocol ColorTagSave {
  func save(color: String, withTag tag: String)
}
