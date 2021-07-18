//
//  Service.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 18/07/21.
//

import Foundation

class Service {
  
  static let shared = Service() // singleton
  
  func fetchApps(completion: @escaping([Result], Error?) -> ()) {
    print("Fetching itunes apps from Service layer")
    
    let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
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
}
