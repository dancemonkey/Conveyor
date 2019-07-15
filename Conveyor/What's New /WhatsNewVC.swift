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
    doneBtn.setTitleColor(ColorStyles.background, for: .normal)
    doneBtn.layer.cornerRadius = 10
    // Do any additional setup after loading the view.
  }
  
  @IBAction func donePressed(sender: UIButton) {
    self.dismiss(animated: true, completion: completion)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
