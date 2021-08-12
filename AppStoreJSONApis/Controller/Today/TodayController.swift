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
        TodayItem.init(category: "LIFE HACK" , title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
        
        TodayItem.init(category: "Daily List" , title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
        
        TodayItem.init(category: "Daily List" , title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),
        
        TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all  you need to know to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9862923026, green: 0.9672421813, blue: 0.7221010327, alpha: 1), cellType: .single, apps: [])
      ]
      
      self.collectionView.reloadData()
    }
  }
  
  var appFullscreenController: AppFullscreenController!
  
  fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
    let fullController = TodayMultipleAppsController(mode: .fullscreen)
    fullController.apps = self.items[indexPath.item].apps
    present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch items[indexPath.item].cellType {
    case .multiple:
      showDailyListFullScreen(indexPath)
    default:
      showSingleAppFullscreen(indexPath: indexPath)
    }
  }
  
  fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
    let appFullscreenController = AppFullscreenController()
    appFullscreenController.todayItem = items[indexPath.row]
    appFullscreenController.dismissHandler = {
      self.handleRemoveRedView()
    }
    appFullscreenController.view.layer.cornerRadius = 16
    self.appFullscreenController = appFullscreenController
  }
  
  fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    
    // absolute coordinates of cell
    guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
    
    self.startingFrame = startingFrame
  }
  
  fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
    let fullscreenView = appFullscreenController.view!
    view.addSubview(fullscreenView)
    
    addChild(appFullscreenController)
        
    self.collectionView.isUserInteractionEnabled =  false
    
    setupStartingCellFrame(indexPath)
    
    guard let startingFrame = self.startingFrame else { return }
    
    // auto layout constraint animations
    // 4 anchors
    
    self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
    
    self.view.layoutIfNeeded()
  }
  
  var anchoredConstraints: AnchoredConstraints?
  
  fileprivate func beginAnimationAppFullscreen() {
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      
      self.anchoredConstraints?.top?.constant = 0
      self.anchoredConstraints?.leading?.constant = 0
      self.anchoredConstraints?.width?.constant = self.view.frame.width
      self.anchoredConstraints?.height?.constant = self.view.frame.height
      
      self.view.layoutIfNeeded() // starts animation
      
      guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
      
      cell.todayCell.topConstraint.constant = 48
      cell.layoutIfNeeded()
      
      //      redView.frame = self.view.frame
      
      // hide tabbar is not working for some reason
      //      self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
      
    }, completion: nil)
  }
  
  fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
    // #1
    setupSingleAppFullscreenController(indexPath)
    
    // #2 setup fullscreen in its starting position
    setupAppFullscreenStartingPosition(indexPath)
    
    // #3 begin the fullscreen animation
    beginAnimationAppFullscreen()
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
      
      self.anchoredConstraints?.top?.constant = startingFrame.origin.y
      self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
      self.anchoredConstraints?.width?.constant = startingFrame.width
      self.anchoredConstraints?.height?.constant = startingFrame.height
      
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
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
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
