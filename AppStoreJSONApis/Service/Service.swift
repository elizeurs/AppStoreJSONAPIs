//
//  Service.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 18/07/21.
//

import Foundation

class Service {
  
  static let shared = Service() // singleton
  
  func fetchApps(searchTerm: String, completion: @escaping([Result], Error?) -> ()) {
    print("Fetching itunes apps from Service layer")
    
    let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
    guard let url = URL(string: urlString) else { return }

    // fetch data from internet
    URLSession.shared.dataTask(with: url) { (data, resp, err) in

      if let err = err {
        print("Failed to fetch apps:", err)
        completion([], nil)
        return
      }

      // sucess
//      print(data)
//      print(String(data: data!, encoding: .utf8))

      guard let data = data else { return }
      do {
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        
        completion(searchResult.results, nil)

//        self.appResults = searchResult.results
//
//        DispatchQueue.main.async {
//          self.collectionView.reloadData()
//        }
        
        print(searchResult)
        
//        searchResult.results.forEach({print($0.trackName, $0.primaryGenreName)})
      } catch let jsonErr {
        print("Failed to decode json:", jsonErr)
        completion([], jsonErr)
      }
    }.resume()  // fires off the request
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
    guard let url =  URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, resp, err) in
//      print(data)
//      print(String(data: data!, encoding: .utf8))
      
      if let err = err {
        completion(nil, err)
        return
      }
      
      do {
        let appGroup = try JSONDecoder().decode(AppGroup.self, from: data!)
//        print(appGroup.feed.results)
//        appGroup.feed.results.forEach ({ print($0.name)})
        
        // success
        completion(appGroup, nil)
      } catch {
        completion(nil, error)
        print("Failed to decode:", error)
      }
            
    }.resume() // this will fire your request
  }
}
