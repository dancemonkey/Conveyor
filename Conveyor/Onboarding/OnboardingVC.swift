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
  private var screenshots: [UIImage] = []
  
  fileprivate lazy var pages: [UIViewController] = {
    return [
      self.getViewController(withIdentifier: "page1", and: titleText[0], lastVC: false),
      self.getViewController(withIdentifier: "page1", and: titleText[1], lastVC: false),
      self.getViewController(withIdentifier: "page1", and: titleText[2], lastVC: false),
      self.getViewController(withIdentifier: "page1", and: titleText[3], lastVC: false),
      self.getViewController(withIdentifier: "page1", and: titleText[4], lastVC: false),
      self.getViewController(withIdentifier: "page1", and: titleText[5], lastVC: true)
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
    ("Welcome to Conveyor!", "Using Conveyor is simple. Just create tasks, scheduling them into one of three lists (Today, Tomorrow, or Later), then start getting things done!"),
    ("Create a task", #"Tap on the "Add new task" field, type in the title, then select when you want the task scheduled."#),
    ("Swipe right to complete a task", "Swipe left to see other options, like reschedule (to move a task to another list) and delete."),
    ("Tasks reschedule themselves daily", #"After midnight (or the first time you open the app each day), “Later” tasks move to “Tomorrow”, “Tomorrow” tasks move to “Today”, and "Today" tasks become overdue."#),
    ("Lock tasks in the Later list", #"A “Later” task can be held in place for any number of days, or forever (until you unlock it). Just in case you don't feel like dealing with it for a while."#),
    ("You're ready to get started!", #"We're just going to ask for a couple of authorizations, so that you can see badges for what's due today and use Siri to add tasks."#)
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
