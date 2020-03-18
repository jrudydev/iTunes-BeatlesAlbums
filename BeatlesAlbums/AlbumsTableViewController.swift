//
//  ViewController.swift
//  BeatlesAlbums
//
//  Created by Rudy Gomez on 3/16/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import UIKit

let albumCellId = "albumcell"

class AlbumsTableViewViewController: UITableViewController {
  
  private enum Section: Int {
    case main
  }
  
  private let api = iTunesAPI()
  private var datasource: UITableViewDiffableDataSource<Section, Album>!
  
  private var albums: [Album] = [] {
    didSet {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        guard #available(iOS 13, *) else {
          self.tableView.reloadData()
          return
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Album>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.albums)
        self.datasource.apply(snapshot, animatingDifferences: true)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureDatasource()
    loadTableViewData()
  }
  
  private func configureDatasource() {
    self.datasource = UITableViewDiffableDataSource(tableView: self.tableView, cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
      let cell = self.tableView.dequeueReusableCell(withIdentifier: albumCellId, for: indexPath)
      guard let albumCell = cell as? AlbumTableViewCell else { return cell }
      
      albumCell.albumTitle?.text = self.albums[indexPath.row].name
      if let imageUrl = self.albums[indexPath.row].imageURL, let url = URL(string: imageUrl) {
        albumCell.albumImage.fetchImage(url)
      }
      
      return albumCell
    })
  }
  
  private func loadTableViewData() {
    self.api.fetchAlbums() { albums, error in
      guard error == nil else { print(error!.localizedDescription); return }
      
      let filteredAlbums = albums.filter { $0.collectionType == "Album" }
      self.albums = filteredAlbums
    }
  }
}

extension AlbumsTableViewViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.albums.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: albumCellId, for: indexPath)
    guard let albumCell = cell as? AlbumTableViewCell else { return cell }
    
    albumCell.albumTitle?.text = self.albums[indexPath.row].name
    if let imageUrl = self.albums[indexPath.row].imageURL, let url = URL(string: imageUrl) {
      albumCell.albumImage.fetchImage(url)
    }
    
    return albumCell
  }
}

