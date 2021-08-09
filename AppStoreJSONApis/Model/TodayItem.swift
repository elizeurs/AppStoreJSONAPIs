//
//  TodayItem.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 06/08/21.
//

import UIKit

struct TodayItem {
  
  let category: String
  let title: String
  let image: UIImage
  let description: String
  let backgroundColor: UIColor
  
  // enum
  let cellType: CellType
  
  enum CellType: String {
    case single, multiple
  }
}
