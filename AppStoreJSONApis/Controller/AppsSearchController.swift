//
//  AppsSearchController.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 14/07/21.
//

import UIKit
import SDWebImage

class AppsSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

  fileprivate let cellId = "id1234"
  
  fileprivate let searchController = UISearchController(searchResultsController: nil)
  
  fileprivate let enterSearchTermLabel: UILabel = {
    let label = UILabel()
    label.text = "Please enter search term above..."
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    return label
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      collectionView.backgroundColor = .white
      collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
      
      collectionView.addSubview(enterSearchTermLabel)
      enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
      
      setupSearchBar()
      
//      fetchITunesApps()

    }
  
  fileprivate func setupSearchBar() {
    definesPresentationContext = true
    navigationItem.searchController = self.searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchBar.delegate = self
  }
  
  var timer: Timer?
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchBar)
    
    timer?.invalidate()
    
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
      Service.shared.fetchApps(searchTerm: searchText) { (res, err) in
        
        // this will actually fire my search
        self.appResults = res
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    })
  }
  
  fileprivate var appResults = [Result]()
  
  fileprivate  func fetchITunesApps() {
    Service.shared.fetchApps(searchTerm: "instagram") { (results, err) in
      
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
    enterSearchTermLabel.isHidden = appResults.count != 0
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
