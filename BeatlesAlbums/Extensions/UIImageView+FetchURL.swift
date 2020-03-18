//
//  UIImageView+FetchImage.swift
//  BeatlesAlbums
//
//  Created by Rudy Gomez on 3/16/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import Foundation
import UIKit

var imageCache = [String: UIImage]()

extension UIImageView {
  func fetchImage(_ url: URL, placeholder: UIImage? = nil) {
    if let image = imageCache[url.absoluteString] {
      self.image = image
      return
    }
    
    if let placeholder = placeholder {
      self.image = placeholder
    }
  
    let currentUrl = url
    let _ = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let data = data, error == nil else {
        print(error!)
        return
      }
      
      DispatchQueue.main.async {
        if currentUrl == url {
          let image = UIImage(data: data)
          self?.image = image
          imageCache[url.absoluteString] = image
        }
      }
    }.resume()
  }
}
