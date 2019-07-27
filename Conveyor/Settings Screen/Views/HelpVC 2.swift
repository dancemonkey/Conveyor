//
//  HelpVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 5/30/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import WebKit

class HelpVC: UIViewController {
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let url = Bundle.main.url(forResource: "help", withExtension: "html") {
      webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    webView.navigationDelegate = self
    styleViews()
  }
  
  func styleViews() {
    view.backgroundColor = ColorStyles.background
    webView.backgroundColor = .clear
    webView.isHidden = true
    spinner.hidesWhenStopped = true
    spinner.isHidden = false
    spinner.startAnimating()
  }
  
}

extension HelpVC: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    let css = "body { background-color : #\(ColorStyles.background.toHex!); color : #\(ColorStyles.textColor.toHex!); }"
    let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
    webView.evaluateJavaScript(js, completionHandler: nil)
    spinner.stopAnimating()
    webView.isHidden = false
  }
}
