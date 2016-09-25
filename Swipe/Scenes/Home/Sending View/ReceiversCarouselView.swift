//
//  ReceiversCarouselView.swift
//  Swipe
//
//  Created by Guowei Mo on 25/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class ReceiversCarouselView: iCarousel, iCarouselDelegate, iCarouselDataSource {
  
  var imageItems: [UIImage?] = []
  var viewRect: CGRect = CGRect.zero
  
  var highlightedViewInset: CGFloat = 0.0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    delegate = self
    dataSource = self
    scrollToItemBoundary = true
    clipsToBounds = false
    
    type = .linear
//    let offset = -frame.height * 1.3
//    viewpointOffset = CGSize(width: 0, height: 1.2 * offset)
    contentOffset = CGSize(width: 0, height: 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateView(_ items: [UIImage?])
  {
    imageItems = items
    viewRect = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.height * 0.9,
                                                         height: frame.height * 0.9))
    reloadData()
    scrollToItem(at: 1, animated: true)
  }
  
  //MARK: carousel delegates
  func numberOfItems(in carousel: iCarousel) -> Int {
    return imageItems.count
  }
  
  func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
    switch(option)
    {
      case .spacing:
        return value * 1.1
      default: return value
    }
  }
  
  func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
    return viewRect.width
  }
  
  func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
    var imageView = view
    if imageView == nil
    {
      imageView = UIImageView(frame: viewRect)
      (imageView as! UIImageView).image = imageItems[index]
      imageView?.contentMode = .scaleAspectFill
      imageView?.layer.cornerRadius = viewRect.height / 2.0
      imageView?.clipsToBounds = true
    }
    return imageView!
  }
  
  func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
    visibleItemViews.forEach { (view) in
      (view as! UIView).layer.borderWidth = 0
    }
    if let itemView = itemView(at: index) as? UIImageView
    {
      itemView.layer.borderWidth = 5
      itemView.layer.borderColor = Common.appRedColor().cgColor
    }
  }
}

