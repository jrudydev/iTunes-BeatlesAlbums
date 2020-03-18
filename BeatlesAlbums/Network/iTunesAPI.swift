//
//  iTunesAPI.swift
//  BeatlesAlbums
//
//  Created by Rudy Gomez on 3/16/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import Foundation

class iTunesAPI {
  let endpoint = "https://itunes.apple.com/lookup?id=136975&entity=album"
  
  func fetchAlbums(_ completion: @escaping ([Album], Error?) -> Void) {
    guard let url = URL(string: self.endpoint) else { fatalError("URL not parsable.") }
    
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
