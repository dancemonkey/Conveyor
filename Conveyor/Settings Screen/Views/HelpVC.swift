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
  // MARK: Using WKWebView
  // https://www.hackingwithswift.com/articles/112/the-ultimate-guide-to-wkwebview
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let url = Bundle.main.url(forResource: "help", withExtension: "html") {
      webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
  }
  
}
