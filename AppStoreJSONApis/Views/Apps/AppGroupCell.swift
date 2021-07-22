//
//  AppGroupCell.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 19/07/21.
//

import UIKit

class AppsGroupCell: UICollectionViewCell {
  
  let titleLabel = UILabel(text: "App Section", font: .boldSystemFont(ofSize: 30))
  
  let horizontalController = AppsHorizontalController()
  
//  let titleLabel: UILabel = {
//    let label = UILabel()
//    label.text = "App Section"
//    label.font = .boldSystemFont(ofSize: 30)
//    return label
//  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
//    backgroundColor = .lightGray
    
    addSubview(titleLabel)
    titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
    
    addSubview(horizontalController.view)
//    horizontalController.view.backgroundColor = .blue
    horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
