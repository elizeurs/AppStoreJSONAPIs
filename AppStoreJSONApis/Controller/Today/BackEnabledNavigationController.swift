//
//  BackEnabledNavigationController.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 10/08/21.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.interactivePopGestureRecognizer?.delegate = self
  }
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return self.viewControllers.count > 1
  }
}
