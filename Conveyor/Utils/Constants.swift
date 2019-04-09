//
//  Constants.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/6/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

enum DefaultKeys: String {
  case bucketChangeDate
}

enum ItemActions: String {
  case hold, move, delete, complete
  
  func getImage() -> UIImage {
    return UIImage(named: "\(self.rawValue)")!
  }
  
  func getUnCompleteImage() -> UIImage {
    return UIImage(named: "unComplete")!
  }
  
  func getUnholdImage() -> UIImage {
    return UIImage(named: "unLock")!
  }
}
