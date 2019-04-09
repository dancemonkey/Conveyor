//
//  ToastFactory.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/22/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

enum Direction {
  case top, bottom, left, right
}

enum ToastTiming: CGFloat {
  typealias RawValue = CGFloat
  case toastUp = 0.75
  case toastHold = 0.9
  case toastDown = 0.4
}

struct ToastMessages {
  private static let positiveMessages: [String] = [
    "Nice work!",
    "Go get 'em!",
    "Attaboy (or girl)!",
    "Keep it up!",
    "Don't stop now!",
    "Excellent!",
    "Good work!",
    "Done, and done.",
    "You got it, boss.",
    "Alrighty!",
    "That's a spicy meatball!",
    "My pleasure, governor.",
    "Cross it off the list!",
    "Feels good, don't it?",
    "Consider it done.",
    "Aye aye, captain.",
    "I love it when a plan comes together.",
    "That's what I'm talking about!",
    "I like it!",
    "Nice job!",
    "You're the best."
  ]
  
  static func getPositiveMessage() -> String {
    return positiveMessages.randomElement() ?? "Great work!"
  }
}

class ToastFactory {
  static func newToast(from direction: Direction, withText text: String, parent: UIViewController) {
    let size: (width: CGFloat, height: CGFloat) = (parent.view.frame.width, 55.0)
    let frame = CGRect(x: 20.0, y: parent.view.frame.height + size.height + 10, width: size.width - 40.0, height: size.height)
    let toast = ToastView(text: text, frame: frame)
    parent.view.addSubview(toast)
    animateAppearance(of: toast, from: direction)
  }
  
  private static func animateAppearance(of toast: ToastView, from direction: Direction) {
    // switch direction
    // for now just coming up from bottom
    let originalFrame = toast.frame
    let newY = originalFrame.height * 2.5
    let newFrame = originalFrame.offsetBy(dx: 0.0, dy: -newY)
    UIView.animate(withDuration: TimeInterval(ToastTiming.toastUp.rawValue), animations: {
      // move into view
      toast.frame = newFrame
    }) { (_) in
      DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(ToastTiming.toastHold.rawValue), execute: {
        UIView.animate(withDuration: TimeInterval(ToastTiming.toastDown.rawValue), animations: {
          // move out of view after delay in place
          toast.frame = originalFrame
        }, completion: { (_) in
          toast.removeFromSuperview()
        })
      })
    }
  }
}
