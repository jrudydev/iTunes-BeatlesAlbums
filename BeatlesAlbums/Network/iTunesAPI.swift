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
    static let baseURL = "https://itunes.apple.com/lookup"
    static let beatlesId = "136975"
    
    case albums
    
    var url: URL? {
      switch self {
      case .albums:
        guard var components = URLComponents(string: EndPoint.baseURL) else { return nil }
        
        components.queryItems = self.queryItems
        return components.url
      }
    }
    
    var queryItems: [URLQueryItem] {
      switch self {
      case .albums:
        return [URLQueryItem(name: "id", value: "\(EndPoint.beatlesId)"),
                URLQueryItem(name: "entity", value: "album")]
      }
    }
  }
  
  func fetchAlbums(_ completion: @escaping ([Album], Error?) -> Void) {
    guard let url = EndPoint.albums.url else { return }
    
    let _ = URLSession.shared.dataTask(with: url) { data, response, error in
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
