//
//  AppFullscreenHeaderCell.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 06/08/21.
//

import UIKit


class AppFullscreenHeaderCell: UITableViewCell {

    let todayCell = TodayCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(todayCell)
        todayCell.fillSuperview()
        
//        contentView.addSubview(closeButton)
//        closeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 44, left: 0, bottom: 0, right: 12), size: .init(width: 80, height: 38))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class AppFullscreenHeaderCell: UITableViewCell {
//
//  let todayCell = TodayCell()
//
//  let closeButton: UIButton = {
//    let button = UIButton(type: .system)
//    button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
//    return button
//  }()
//
//  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//    super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//    addSubview(todayCell)
//    todayCell.fillSuperview()
//
//    addSubview(closeButton)
//    closeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 12), size: .init(width: 80, height: 38))
//  }
//
//  required init?(coder: NSCoder) {
//    fatalError()
//  }
//}
