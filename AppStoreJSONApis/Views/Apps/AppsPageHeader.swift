//
//  AppsPageHeader.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 20/07/21.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {
  
  let appHeaderHorizontalController = AppsHeaderHorizontalController()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
//    backgroundColor = .blue
    
    appHeaderHorizontalController.view.backgroundColor = .purple
    addSubview(appHeaderHorizontalController.view)
    appHeaderHorizontalController.view.fillSuperview()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
