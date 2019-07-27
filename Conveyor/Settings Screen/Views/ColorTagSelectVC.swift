//
//  ColorTagSelectVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 7/23/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ColorTagSelectVC: UIViewController {
  
  @IBOutlet weak var colorLbl: UILabel!
  @IBOutlet weak var customTagField: UITextField!
  @IBOutlet weak var saveBtn: UIButton!
  @IBOutlet weak var atSymbolLbl: UILabel!
  @IBOutlet weak var colorSwatch: UIView!
  
  var colorOption: ColorOption?
  var delegate: ColorTagSave?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    uiStyle()
    if let option = colorOption {
      colorLbl.text = option.getTextValue().uppercased()
      guard let color = Settings.getUserColors?[option.getTextValue()] else {
        customTagField.placeholder = "\(option.getTextValue())"
        return
      }
      customTagField.text = "\(color)"
      colorSwatch.backgroundColor = option.getColor()
      colorSwatch.layer.cornerRadius = colorSwatch.frame.width / 2
    }
  }
  
  func uiStyle() {
    view.backgroundColor = ColorStyles.background
    saveBtn.backgroundColor = ColorStyles.primary
    saveBtn.setTitleColor(ColorStyles.buttonLabel, for: .normal)
    saveBtn.layer.cornerRadius = 4.0
    colorLbl.textColor = ColorStyles.textColor
    atSymbolLbl.textColor = ColorStyles.textColor
  }
  
  @IBAction func savePressed(sender: UIButton) {
    guard let text = customTagField.text, text.isEmpty == false else {
      return
    }
    delegate?.save(color: colorOption!.getTextValue(), withTag: text)
    navigationController?.popViewController(animated: true)
  }
  
}
