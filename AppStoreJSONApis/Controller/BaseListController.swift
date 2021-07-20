//
//  BaseListController.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 19/07/21.
//

import UIKit

class BaseListController: UICollectionViewController {
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
