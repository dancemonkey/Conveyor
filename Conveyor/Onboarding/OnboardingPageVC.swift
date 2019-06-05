//
//  OnboardingPageVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/19/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import AVKit
import Intents

class OnboardingPageVC: UIViewController {
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var subTitleLbl: UILabel!
  @IBOutlet weak var screenshot: UIImageView!
  @IBOutlet weak var skipBtn: UIButton!
  typealias TitleText = (title: String, subtitle: String)
  var text: TitleText?
  var lastVC: Bool = false
  var image: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let titles = text {
      titleLbl.text = titles.title
      subTitleLbl.text = titles.subtitle
    }
    if let img = image {
      self.screenshot.image = img
    }
    styleViews()
  }
  
  private func styleViews() {
    self.view.backgroundColor = ColorStyles.background
    if lastVC {
      skipBtn.setTitle("DONE", for: .normal)
      skipBtn.backgroundColor = ColorStyles.primary
      skipBtn.setTitleColor(ColorStyles.background, for: .normal)
      skipBtn.layer.cornerRadius = 10
    } else {
      skipBtn?.backgroundColor = .clear
      skipBtn?.setTitleColor(ColorStyles.textColor.withAlphaComponent(0.7), for: .normal)
      skipBtn.setTitle("Skip", for: .normal)
    }
    titleLbl.font = FontStyles.onboardingTitleFont
    titleLbl.numberOfLines = 2
    subTitleLbl.font = FontStyles.onboardingSubTitleFont
    subTitleLbl.numberOfLines = 4
  }
  
  func finishOnboarding() {
    UserDefaults.standard.set(true, forKey: Constants.DefaultKeys.hasLaunchedBefore.rawValue)
    if INPreferences.siriAuthorizationStatus() == .notDetermined {
      DispatchQueue.main.async {
        let siriPopup = AlertFactory.siriAuthNotification {
          INPreferences.requestSiriAuthorization { (status) in }
          self.dismiss(animated: true, completion: nil)
        }
        self.present(siriPopup, animated: true, completion: nil)
      }
    } else {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func skipPressed(sender: UIButton) {
    finishOnboarding()
  }
  
}
