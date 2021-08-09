//
//  TodayMultipleAppCell.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 08/08/21.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
  
  override var todayItem: TodayItem! {
    didSet {
      categoryLabel.text = todayItem.category
      titleLabel.text = todayItem.title
    }
  }
  
  
  let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
  let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 32), numberOfLines: 2)
  
  let multipleAppsController = TodayMultipleAppsController()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    layer.cornerRadius = 16
    
    multipleAppsController.view.backgroundColor = .blue
    
    let stackView = VerticalStackView(arrangedSubviews: [
      categoryLabel,
      titleLabel,
      multipleAppsController.view
    ], spacing: 12)
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
