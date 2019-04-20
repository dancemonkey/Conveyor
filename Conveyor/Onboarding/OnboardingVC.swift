//
//  OnboardingVC.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/19/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class OnboardingVC: UIPageViewController {
  
  typealias TextGroup = (title: String, subtitle: String)
  private var titleText: [TextGroup] = []
  
  fileprivate lazy var pages: [UIViewController] = {
    return [
      self.getViewController(withIdentifier: "page1", and: titleText[0], lastVC: false),
      self.getViewController(withIdentifier: "page1", and: titleText[1], lastVC: false),
      self.getViewController(withIdentifier: "page1", and: titleText[2], lastVC: false),
      self.getViewController(withIdentifier: "page1", and: titleText[3], lastVC: true)
    ]
  }()
  
  fileprivate func getViewController(withIdentifier identifier: String, and text: TextGroup, lastVC: Bool) -> UIViewController
  {
    let vc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: identifier) as! OnboardingPageVC
    vc.text = text
    vc.lastVC = lastVC
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.dataSource = self
    titleText = [
    ("Welcome to Conveyor!", "Create tasks just by entering the title and scheduling it for Today, Tomorrow, or Later."),
    ("Swipe right to complete a task.", "Swipe left to see other options, like reschedule and delete."),
    ("Tasks change lists after midnight each night.", #"“Later” tasks move to “Tomorrow”, “Tomorrow” tasks move to “Today”, like a conveyor belt!"#),
    ("You can lock tasks in the Later list.", #"“Later” tasks can be held in place for any number of days, or forever until you unlock them."#)
    ]
    if let firstVC = pages.first {
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    stylePageController()
  }
  
  func stylePageController() {
    let pageControl = UIPageControl.appearance()
    pageControl.pageIndicatorTintColor = ColorStyles.primaryFaded
    pageControl.currentPageIndicatorTintColor = ColorStyles.primary
    pageControl.backgroundColor = ColorStyles.blackText
  }
  
}

extension OnboardingVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
    let prevIndex = vcIndex - 1
    guard prevIndex >= 0 else { return nil }
    guard pages.count > prevIndex else { return nil }
    return pages[prevIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
    let nextIndex = vcIndex + 1
    guard nextIndex < pages.count else { return nil }
    guard pages.count > nextIndex else { return nil }
    return pages[nextIndex]
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return pages.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return 0
  }
  
}
