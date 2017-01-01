//
//  SwipersView.swift
//  Swipe
//
//  Created by Guowei Mo on 31/12/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class AvatarsView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

  var avatars: [UIImage] = []
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    backgroundColor = UIColor.clear
    register(UINib(nibName: "AvatarCell", bundle: nil), forCellWithReuseIdentifier: "avatar")
    delegate = self
    dataSource = self
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: 50, height: 50)
    flowLayout.scrollDirection = .horizontal
    collectionViewLayout = flowLayout
  }
  
  func refreshView(withAvatar avatar: UIImage) {
    avatars.insert(avatar, at: 0)
    reloadData()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return avatars.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatar", for: indexPath) as? AvatarCell {
      if let aid = avatars[indexPath.item].accessibilityIdentifier {
        cell.nameLabel.isHidden = false
        cell.nameLabel.text = aid
        cell.imageView.image = nil
      } else {
        cell.nameLabel.isHidden = true
        cell.imageView.image = avatars[indexPath.item]
      }
      return cell
    }
    return UICollectionViewCell()
  }
  
}
