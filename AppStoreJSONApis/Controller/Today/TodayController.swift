//
//  TodayController.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 04/08/21.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
  
  fileprivate let cellId = "cellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    
    collectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  var appFullscreenController: AppFullscreenController!
  
  var topConstraint: NSLayoutConstraint?
  var leadingConstraint: NSLayoutConstraint?
  var widthConstraint: NSLayoutConstraint?
  var heightConstraint: NSLayoutConstraint?
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let appFullscreenController = AppFullscreenController()
    let redView = appFullscreenController.view!
    redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
    view.addSubview(redView)
    
    addChild(appFullscreenController)
    
    self.appFullscreenController = appFullscreenController
    
    guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    
    // absolute coordinates of cell
    guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
    
    self.startingFrame = startingFrame
//    redView.frame = startingFrame
    
    
    // auto layout constraint animations
    // 4 anchors
    redView.translatesAutoresizingMaskIntoConstraints = false
    topConstraint = redView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
    leadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
    widthConstraint = redView.widthAnchor.constraint(equalToConstant: startingFrame.width)
    heightConstraint = redView.heightAnchor.constraint(equalToConstant: startingFrame.height)
    
    [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
    self.view.layoutIfNeeded()
    
    redView.layer.cornerRadius = 16
    
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      
      self.topConstraint?.constant = 0
      self.leadingConstraint?.constant = 0
      self.widthConstraint?.constant = self.view.frame.width
      self.heightConstraint?.constant = self.view.frame.height
      
      self.view.layoutIfNeeded() // starts animation

//      redView.frame = self.view.frame
      
      // hide tabbar is not working for some reason
//      self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
      
    }, completion: nil)
  }
  
  var startingFrame: CGRect?
  
  @objc func handleRemoveRedView(gesture: UITapGestureRecognizer) {
    // access startingFrame
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
//      redView.frame = self.view.frame
      
      self.appFullscreenController.tableView.contentOffset = .zero
      
      // this frame code is bad
//      gesture.view?.frame = self.startingFrame ?? .zero
      guard let startingFrame = self.startingFrame else { return }
      
      self.topConstraint?.constant = startingFrame.origin.y
      self.leadingConstraint?.constant = startingFrame.origin.x
      self.widthConstraint?.constant = startingFrame.width
      self.heightConstraint?.constant = startingFrame.height
      
      self.view.layoutIfNeeded()
      
      // bring back tabbar is not working for some reason
//      self.tabBarController?.tabBar.transform = .identity
      
    }, completion: { _ in
      gesture.view?.removeFromSuperview()
      self.appFullscreenController.removeFromParent()
    })
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 64, height: 450
    )
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 32, left: 0, bottom: 32, right: 0)
  }
}
