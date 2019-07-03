//
//  ViewController.swift
//  KeikaiExample
//
//  Created by Aashish Tamsya on 03/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import Keikai

final class ViewController: UIViewController {
  @IBOutlet fileprivate weak var messageField: UITextField!
  
  fileprivate var duration = Duration.short
  fileprivate var animationType = AnimationType.slideFromBottomBackToBottom
  fileprivate var messageTextAlignment = NSTextAlignment.left
  
}
// MARK: - @IBActions
private extension ViewController {
  @IBAction func showButtonSelected(_ sender: UIButton) {
    let message = messageField.text ?? "Sample Message"
    let keiKaiView = KeikaiView(message: message, duration: .short)
    keiKaiView.messageTextAlign = messageTextAlignment
    keiKaiView.animationType    = animationType
    keiKaiView.show()
  }
  @IBAction func animationSegmentValueChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      animationType = .slideFromBottomToTop
    case 1:
      animationType = .fadeInFadeOut
    case 2:
      animationType = .slideFromRightToLeft
    case 3:
      animationType = .slideFromLeftToRight
    default:
      animationType = .slideFromBottomBackToBottom
    }
  }
  
  @IBAction func messageTextAlignSegmentValueChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      messageTextAlignment = .left
    case 1:
      messageTextAlignment = .center
    case 2:
      messageTextAlignment = .right
    default:
      messageTextAlignment = .left
    }
  }
  
  @IBAction func showTabBarViewController(_ sender: UIButton) {
    navigationController?.pushViewController(TabBarController.tabBarViewController(), animated: true)
  }
}
