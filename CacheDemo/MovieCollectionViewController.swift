//
//  MovieCollectionViewController.swift
//  MovieCollectionViewController
//
//  Created by Peter Pan on 2021/8/13.
//  Copyright © 2021 SHIH-YING PAN. All rights reserved.
//

import UIKit


class MovieCollectionViewController: UICollectionViewController {
    
    var feeds = [Feed]()
    
    func configureCellSize() {
        let itemSpace: CGFloat = 3
        let columnCount: CGFloat = 3
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount)
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = itemSpace
        flowLayout?.minimumLineSpacing = itemSpace
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCellSize()
        
        NetworkController.shared.fetchTopMovies {[weak self] feeds in
            guard let self = self else { return }
            if let feeds = feeds {
                self.feeds = feeds
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
        backgroundConfiguration.imageContentMode = .scaleAspectFill
        backgroundConfiguration.image = UIImage(systemName: "photo")
        cell.backgroundConfiguration = backgroundConfiguration
        
        let feed = feeds[indexPath.item]
        NetworkController.shared.fetchImage(url: feed.artworkUrl100) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self,
                      let image = image,
                      let item = collectionView.indexPath(for: cell)?.item,
                      feed.id == self.feeds[item].id else { return }
                
                backgroundConfiguration.image = image
                cell.backgroundConfiguration = backgroundConfiguration
            }
        }
        
        return cell

    }
    
    
}
