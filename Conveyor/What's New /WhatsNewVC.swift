//
//  WhatsNewVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 7/15/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class WhatsNewVC: UIViewController {
  
  var completion: (() -> ())?
  @IBOutlet weak var doneBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    doneBtn.backgroundColor = ColorStyles.primary
    doneBtn.setTitleColor(ColorStyles.buttonLabel, for: .normal)
    doneBtn.layer.cornerRadius = 10
  }
  
  @IBAction func donePressed(sender: UIButton) {
    self.dismiss(animated: true, completion: completion)
  }
  
}
