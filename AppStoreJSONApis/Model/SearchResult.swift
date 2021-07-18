//
//  SearchResult.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 17/07/21.
//

import Foundation

struct SearchResult: Decodable {
let resultCount: Int
let results: [Result]
}

struct Result: Decodable {
let trackName: String
let primaryGenreName: String
var averageUserRating: Float?
}
