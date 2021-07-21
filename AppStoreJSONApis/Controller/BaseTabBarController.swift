//
//  BaseTabBarController.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 14/07/21.
//

import UIKit

class BaseTabBarController: UITabBarController {
  
  override func  viewDidLoad() {
    super.viewDidLoad()
    
//    let todayViewController = UIViewController()
//    todayViewController.view.backgroundColor = .white
//    todayViewController.navigationItem.title = "Today"
//    let todayNavController = UINavigationController(rootViewController: todayViewController)
//    todayNavController.tabBarItem.title = "Today"
//    todayNavController.tabBarItem.image = UIImage(named: "today_icon")
//    todayNavController.navigationBar.prefersLargeTitles = true
    
//    let redViewController = UIViewController()
//    redViewController.view.backgroundColor = .white
//    redViewController.navigationItem.title = "Apps"
//    let redNavController = UINavigationController(rootViewController: redViewController)
//    redNavController.tabBarItem.title = "Apps"
//    redNavController.tabBarItem.image = #imageLiteral(resourceName: "apps")
//    redNavController.navigationBar.prefersLargeTitles = true
    
//    let blueViewController = UIViewController()
//    blueViewController.view.backgroundColor = .white
//    blueViewController.navigationItem.title = "Search"
//    let blueNavController = UINavigationController(rootViewController: blueViewController)
//    blueNavController.tabBarItem.title = "Search"
//    blueNavController.tabBarItem.image = #imageLiteral(resourceName: "search")
//    blueNavController.navigationBar.prefersLargeTitles = true
    
    viewControllers = [
//      todayNavController,
//      redNavController,
//      blueNavController
      createNavController(viewController:
                            AppsPageController(), title: "Apps", imageName: "apps"),
      createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search"),
      createNavController(viewController: UIViewController(), title: "Today", imageName: "today_icon")
    ]
  }
  
  fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
    let navController = UINavigationController(rootViewController: viewController)
    navController.navigationBar.prefersLargeTitles = true
    viewController.navigationItem.title = title
    viewController.view.backgroundColor = .white
    navController.tabBarItem.title = title
    navController.tabBarItem.image = UIImage(named: imageName)
    return navController
  }
}
