//
//  TodayController.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 04/08/21.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
  
  var items = [TodayItem]()
  
  let activityIndicatorView: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .large)
    aiv.color = .darkGray
    aiv.startAnimating()
    aiv.hidesWhenStopped = true
    return aiv
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.tabBar.superview?.setNeedsLayout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(activityIndicatorView)
    activityIndicatorView.centerInSuperview()
    
    fetchData()
    
    navigationController?.isNavigationBarHidden = true
    
    collectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
    collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
  }
  
  fileprivate func fetchData() {
    // dispatchGroup
    
    let dispatchGroup = DispatchGroup()
    
    var topGrossingGroup: AppGroup?
    var gamesGroup: AppGroup?
    
    dispatchGroup.enter()
    Service.shared.fetchTopGrossing { (AppGroup, err) in
      // make sure to check your errors
      topGrossingGroup = AppGroup
      
      dispatchGroup.leave()
    }
    
    dispatchGroup.enter()
    Service.shared.fetchGames { (AppGroup, err) in
      gamesGroup = AppGroup
      dispatchGroup.leave()
    }
    
    // completion block
    dispatchGroup.notify(queue: .main) {
      // i'll have access to top grossing and games somehow
      print("Finished fetching")
      self.activityIndicatorView.stopAnimating()
            
      self.items = [
        TodayItem.init(category: "Daily List" , title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
        
        TodayItem.init(category: "Daily List" , title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),
        
        TodayItem.init(category: "LIFE HACK" , title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: [])
      ]
      
      self.collectionView.reloadData()
    }
  }
  
  var appFullscreenController: AppFullscreenController!
  
  var topConstraint: NSLayoutConstraint?
  var leadingConstraint: NSLayoutConstraint?
  var widthConstraint: NSLayoutConstraint?
  var heightConstraint: NSLayoutConstraint?
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if items[indexPath.item].cellType == .multiple {
      let fullController = TodayMultipleAppsController(mode: .fullscreen)
      fullController.apps = self.items[indexPath.item].apps
      present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
      return
    }
    
    let appFullscreenController = AppFullscreenController()
    appFullscreenController.todayItem = items[indexPath.row]
    appFullscreenController.dismissHandler = {
      self.handleRemoveRedView()
    }
    let fullscreenView = appFullscreenController.view!
    view.addSubview(fullscreenView)
    
    addChild(appFullscreenController)
    
    self.appFullscreenController = appFullscreenController
    
    self.collectionView.isUserInteractionEnabled =  false
    
    guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    
    // absolute coordinates of cell
    guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
    
    self.startingFrame = startingFrame
    //    redView.frame = startingFrame
    
    
    // auto layout constraint animations
    // 4 anchors
    fullscreenView.translatesAutoresizingMaskIntoConstraints = false
    topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
    leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
    widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
    heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
    
    [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
    self.view.layoutIfNeeded()
    
    fullscreenView.layer.cornerRadius = 16
    
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      
      self.topConstraint?.constant = 0
      self.leadingConstraint?.constant = 0
      self.widthConstraint?.constant = self.view.frame.width
      self.heightConstraint?.constant = self.view.frame.height
      
      self.view.layoutIfNeeded() // starts animation
      
      guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
      
      cell.todayCell.topConstraint.constant = 48
      cell.layoutIfNeeded()
      
      //      redView.frame = self.view.frame
      
      // hide tabbar is not working for some reason
      //      self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
      
    }, completion: nil)
  }
  
  var startingFrame: CGRect?
  
  @objc func handleRemoveRedView() {
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
      
      guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
      
      cell.todayCell.topConstraint.constant = 48
      cell.layoutIfNeeded()
      
      // bring back tabbar is not working for some reason
      //      self.tabBarController?.tabBar.transform = .identity
      
    }, completion: { _ in
      //      gesture.view?.removeFromSuperview()
      self.appFullscreenController.view.removeFromSuperview()
      self.appFullscreenController.removeFromParent()
      self.collectionView.isUserInteractionEnabled = true
    })
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cellId = items[indexPath.item].cellType.rawValue
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
    cell.todayItem = items[indexPath.item]

    (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
    
    return cell
  }
  
  @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
    
    let collectionView = gesture.view
    
    // figure out which cell were clicking into
    
    var superview = collectionView?.superview
    
    while superview != nil {
      if let cell = superview as? TodayMultipleAppCell {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        
        let apps = self.items[indexPath.item].apps
        
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = apps
        present(fullController, animated: true)
        return
      }
      
      superview = superview?.superview
    }
  }
  
  static let cellSize: CGFloat = 500
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 64, height: TodayController.cellSize
    )
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 32, left: 0, bottom: 32, right: 0)
  }
}
