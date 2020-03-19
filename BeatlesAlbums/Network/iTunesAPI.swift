//
//  iTunesAPI.swift
//  BeatlesAlbums
//
//  Created by Rudy Gomez on 3/16/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import Foundation

class iTunesAPI {
  enum EndPoint {
    static let baseURL = URL(string: "https://itunes.apple.com/lookup?id=136975&entity=album")!
    
    case albums
    
    var url: URL {
      switch self {
      case .albums:
        return EndPoint.baseURL
      }
    }
  }
  
  func fetchAlbums(_ completion: @escaping ([Album], Error?) -> Void) {
    let _ = URLSession.shared.dataTask(with: EndPoint.albums.url) { data, response, error in
      guard let data = data, error == nil else {
        completion([], error)
        return
      }
      
      do {
        let jsonData = try JSONDecoder().decode(Albums.self, from: data)
        if let results = jsonData.results {
          completion(results, nil)
        }
      } catch {
        print(error)
      }
    }.resume()
  }
}
