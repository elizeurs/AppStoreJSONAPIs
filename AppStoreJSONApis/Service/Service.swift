//
//  Service.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 18/07/21.
//

import Foundation

class Service {
  
  static let shared = Service() // singleton
  
  func fetchApps(searchTerm: String, completion: @escaping(SearchResult?, Error?) -> ()) {
    print("Fetching itunes apps from Service layer")
    
    let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"

    fetchGenericJSONData(urlString: urlString, completion: completion)
  }
  
  func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> ()) {
    let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
    fetchAppGroup(urlString: urlString, completion: completion)
  }
  
  func fetchGames(completion: @escaping (AppGroup?, Error?) -> ()) {
    fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json", completion: completion)
  }
  
  //helper
  func fetchAppGroup(urlString: String, completion: @escaping(AppGroup?, Error?)  -> Void) {
    fetchGenericJSONData(urlString: urlString, completion: completion)
  }
  
  func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
    let urlString = "https://api.letsbuildthatapp.com/appstore/social"
    fetchGenericJSONData(urlString: urlString, completion: completion)
  }
  
  // declare my generic json function here
  func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping(T?, Error?) -> ()) {
    
    print("T is type:", T.self)
    
    guard let url =  URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { (data, resp, err) in
//      print(data)
//      print(String(data: data!, encoding: .utf8))
      
      if let err = err {
        completion(nil, err)
        return
      }
      
      do {
        let objects = try JSONDecoder().decode(T.self, from: data!)
//        print(appGroup.feed.results)
//        appGroup.feed.results.forEach ({ print($0.name)})
        
        // success
        completion(objects, nil)
      } catch {
        completion(nil, error)
      }
    }.resume() // this will fire your request
  }
}
