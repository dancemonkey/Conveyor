//
//  OnboardingPageVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/19/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class OnboardingPageVC: UIViewController {
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var subTitleLbl: UILabel!
  @IBOutlet weak var screenshot: UIImageView!
  @IBOutlet weak var doneBtn: UIButton!
  @IBOutlet weak var skipBtn: UIButton!
  typealias TitleText = (title: String, subtitle: String)
  var text: TitleText?
  var lastVC: Bool = false
    
  override func viewDidLoad() {
    super.viewDidLoad()
    if let titles = text {
      titleLbl.text = titles.title
      subTitleLbl.text = titles.subtitle
    }
    if lastVC {
      doneBtn.isHidden = false
    } else {
      doneBtn.isHidden = true
    }
    styleViews()
  }
  
  func setText(for title: String, andSubtitle subtitle: String) {
    self.titleLbl.text = title
    self.subTitleLbl.text = subtitle
  }
  
  func setImage(_ image: UIImage) {
    self.screenshot.image = image
  }
  
  private func styleViews() {
    self.view.backgroundColor = ColorStyles.backgroundWhite
    doneBtn.backgroundColor = ColorStyles.primary
    doneBtn.layer.cornerRadius = 10.0
    doneBtn.setTitleColor(ColorStyles.backgroundWhite, for: .normal)
    skipBtn?.backgroundColor = .clear
    skipBtn?.setTitleColor(ColorStyles.blackText.withAlphaComponent(0.7), for: .normal)
    titleLbl.font = FontStyles.onboardingTitleFont
    titleLbl.numberOfLines = 2
    subTitleLbl.font = FontStyles.onboardingSubTitleFont
    subTitleLbl.numberOfLines = 3
  }
  
  @IBAction func skipPressed(sender: UIButton) {
    // hack to test if works
    self.dismiss(animated: true, completion: nil)
//    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func donePressed(sender: UIButton) {
    // hack to test if works
    self.dismiss(animated: true, completion: nil)
//    self.dismiss(animated: true, completion: nil)
  }
  
}
