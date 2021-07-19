//
//  AppsSearchController.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 14/07/21.
//

import UIKit
import SDWebImage

class AppsSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  fileprivate let cellId = "id1234"
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      collectionView.backgroundColor = .white
      
      collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
      
      fetchITunesApps()

    }
  
  fileprivate var appResults = [Result]()
  
  fileprivate  func fetchITunesApps() {
    Service.shared.fetchApps { (results, err) in
      
      if let err = err {
        print("Failed to fetch apps:", err)
        return
      }
      
      self.appResults = results
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 350)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return appResults.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
//    cell.nameLabel.text = "HERE IS MY APP NAME"
    cell.appResult = appResults[indexPath.item]
    
//    cell.appIconImageView
//    cell.screenshot1ImageView
    
    return cell
  }
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
