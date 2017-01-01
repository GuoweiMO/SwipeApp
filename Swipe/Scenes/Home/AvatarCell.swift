//
//  AvatarCell.swift
//  Swipe
//
//  Created by Guowei Mo on 31/12/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    imageView.layer.cornerRadius = imageView.frame.width / 2
    imageView.clipsToBounds = true
  }
  
}
