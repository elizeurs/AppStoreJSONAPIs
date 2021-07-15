//
//  AppsSearchController.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 14/07/21.
//

import UIKit

class AppsSearchController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
      collectionView.backgroundColor = .red

    }
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
