//
//  RowController.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/1/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import WatchKit

class RowController: NSObject {
  @IBOutlet weak var itemLabel: WKInterfaceLabel!
  @IBOutlet weak var priorityIcon: WKImage!
  @IBOutlet weak var repeatIcon: WKImage!
  @IBOutlet weak var repeatIconGroup: WKInterfaceGroup!
  @IBOutlet weak var priorityIconGroup: WKInterfaceGroup!
  @IBOutlet weak var doneBtn: WKInterfaceButton!
  @IBOutlet weak var doneBtnImg: WKInterfaceImage!
  var taskCompletion: (() -> ())?
  
  @IBAction func completeTask() {
    self.doneBtnImg.setImage(UIImage(named: "circleCheck"))
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.taskCompletion?()
    }
  }
  
//  private func createContext() -> CGContext? {
//    UIGraphicsBeginImageContextWithOptions(CGSize(width: 20.0, height: 20.0), false, 1.0)
//    let context = UIGraphicsGetCurrentContext()
//    context?.beginPath()
//    return context
//  }
  
//  func drawCircle(color: UIColor) {
//    let context = createContext()
//    let diameter = 19
//    context?.setLineWidth(2.0)
//    context?.setStrokeColor(UIColor.black.cgColor)
//    context?.setFillColor(color.cgColor)
//    let path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: diameter, height: diameter), transform: nil)
//    context?.addPath(path)
//    context?.drawPath(using: .fillStroke)
//  }
  
}
