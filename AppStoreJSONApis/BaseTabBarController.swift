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
    
    let redViewController = UIViewController()
    redViewController.view.backgroundColor = .white
    redViewController.navigationItem.title = "Apps"
    
    let redNavController = UINavigationController(rootViewController: redViewController)
    redNavController.tabBarItem.title = "Apps"
    redNavController.tabBarItem.image = #imageLiteral(resourceName: "apps")
    redNavController.navigationBar.prefersLargeTitles = true
    
    let blueViewController = UIViewController()
    blueViewController.view.backgroundColor = .white
    blueViewController.navigationItem.title = "Search"
    
    let blueNavController = UINavigationController(rootViewController: blueViewController)
    blueNavController.tabBarItem.title = "Search"
    blueNavController.tabBarItem.image = #imageLiteral(resourceName: "search")
    blueNavController.navigationBar.prefersLargeTitles = true
    
    viewControllers = [
      redNavController,
      blueNavController,
    ]
  }
}
