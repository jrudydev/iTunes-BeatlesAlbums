//
//  Album.swift
//  BeatlesAlbums
//
//  Created by Rudy Gomez on 3/16/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import Foundation

struct Albums: Codable {
  var results: [Album]?
}

struct Album: Codable, Hashable {
  var imageURL: String?
  var name: String?
  var collectionType: String?
  
  
  private enum CodingKeys: String, CodingKey {
    case imageURL = "artworkUrl100"
    case name = "collectionName"
    case collectionType
  }
}
