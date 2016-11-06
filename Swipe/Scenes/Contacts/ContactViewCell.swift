//
//  ContactViewCell.swift
//  Swipe
//
//  Created by Guowei Mo on 05/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class ContactViewCell: UICollectionViewCell {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var workTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    layer.cornerRadius = 3.0
  }
}
