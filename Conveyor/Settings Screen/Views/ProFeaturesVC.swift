//
//  ProFeaturesVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 6/10/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import WebKit

class ProFeaturesVC: UIViewController {
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var goProBtn: UIButton!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var purchaseSpinner: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()
    if let url = Bundle.main.url(forResource: "proFeatures", withExtension: "html") {
      webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    styleViews()
    webView.navigationDelegate = self
  }
  
  func styleViews() {
    if IAPStore.shared.isProUser() {
      goProBtn.setTitle("PRO USER!", for: .normal)
      goProBtn.isEnabled = false
    }
    webView.isHidden = true
    spinner.hidesWhenStopped = true
    spinner.isHidden = false
    spinner.startAnimating()
    purchaseSpinner.hidesWhenStopped = true
    purchaseSpinner.isHidden = true
    goProBtn.backgroundColor = ColorStyles.primary
    goProBtn.setTitleColor(ColorStyles.textColor, for: .normal)
    goProBtn.layer.cornerRadius = 4.0
    view.backgroundColor = ColorStyles.background
    webView.backgroundColor = .clear
  }
  
  @IBAction func goProTapped(sender: UIButton) {
    startPurchase()
  }
  
  func startPurchase() {
    goProBtn.isHidden = true
    purchaseSpinner.startAnimating()
    IAPStore.shared.purchasePro {
      self.stopPurchase()
    }
  }
  
  func stopPurchase() {
    goProBtn.isHidden = false
    purchaseSpinner.stopAnimating()
  }
}

extension ProFeaturesVC: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    let css = "body { background-color : #\(ColorStyles.background.toHex!); color : #\(ColorStyles.textColor.toHex!); }"
    let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
    webView.evaluateJavaScript(js, completionHandler: nil)
    spinner.stopAnimating()
    webView.isHidden = false
  }
}
