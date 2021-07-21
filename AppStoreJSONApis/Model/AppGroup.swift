//
//  AppGroup.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 21/07/21.
//

import Foundation

struct AppGroup: Decodable {
  let feed: Feed
}

struct Feed: Decodable {
  let title: String
  let results: [FeedResult]
}

struct FeedResult: Decodable {
  let name, artistName, artworkUrl100: String
}
