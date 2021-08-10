//
//  TodayMultipleAppsController.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 08/08/21.
//

import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
  
  let cellId = "cellId"
  
  var results = [FeedResult]()
  
  let closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
    button.tintColor = .darkGray
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  @objc func handleDismiss() {
    dismiss(animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if mode == .fullscreen {
      setupCloseButton()
    } else {
      collectionView.isScrollEnabled = false
    }
        
    collectionView.backgroundColor = .white
    
    collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  override var prefersStatusBarHidden: Bool { return true}
  
  func setupCloseButton() {
    view.addSubview(closeButton)
    closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if mode == .fullscreen {
      return results.count
    }
    
    return min(4, results.count)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
    cell.app = self.results[indexPath.item]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height: CGFloat = 74
    
    return .init(width: view.frame.width, height: height)
  }
  
  fileprivate let spacing: CGFloat = 16
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }
  
  fileprivate let mode: Mode
  
  enum Mode {
    case small, fullscreen
  }
  
  init(mode: Mode) {
    self.mode = mode
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
