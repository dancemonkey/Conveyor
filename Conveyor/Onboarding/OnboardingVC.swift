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
  private var videoFiles: [String?] = []
  
  fileprivate lazy var pages: [UIViewController] = {
    var vcs: [OnboardingPageVC] = []
    for i in 0...4 {
      vcs.append(self.getViewController(withIdentifier: "page1", and: titleText[i], image: screenshots[i], lastVC: false) as! OnboardingPageVC)
    }
    vcs.last?.lastVC = true
    return vcs
  }()
  
  fileprivate func getViewController(withIdentifier identifier: String, and text: TextGroup, image: UIImage, lastVC: Bool) -> UIViewController
  {
    let vc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: identifier) as! OnboardingPageVC
    vc.text = text
    vc.lastVC = lastVC
    vc.image = image
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.dataSource = self
    titleText = [
      ("Welcome to Conveyor!", #"Add new tasks by tapping the "Add New Task" field near the bottom of every screen, then assign it Today, Tomorrow, or Later."#),
      ("Swipe for actions", "Swipe right to complete, swipe left to see other task actions."),
      ("Tasks reschedule themselves daily", #"At the first launch each day, tasks change lists (Later moves to Tomorrow moves to Today)."#),
      ("Lock tasks in the Later list", #"A “Later” task can be locked in place, so it remains there for as long as you like."#),
      ("You're ready to get started!", #"We're just going to ask for a couple of authorizations, so that you can see badges for what's due today and use Siri to add tasks."#)
    ]
    screenshots = [
      // 0. Welcome screenshot and creating a task
      UIImage(named: "welcome.png")!,
      // 2. Swipe actions on tasks
      UIImage(named: "completeTask.png")!,
      // 3. Tasks moving from list to list daily
      UIImage(named: "tasksMove.png")!,
      // 4. Locking tasks on Later list
      UIImage(named: "lockTasks.png")!,
      // 5. All done/get started using app
      UIImage(named: "allDone.png")!
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
    pageControl.backgroundColor = ColorStyles.textColor
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
