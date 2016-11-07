//
//  ContactsCarouselView.swift
//  Swipe
//
//  Created by Guowei Mo on 07/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class ContactsCarouselView: iCarousel, iCarouselDelegate, iCarouselDataSource {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    delegate = self
    dataSource = self
    
    clipsToBounds = false
    scrollToItemBoundary = true
    
    type = .linear
    
    viewpointOffset = CGSize(width: 0, height: 30.0)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateView()
  {
    reloadData()
  }
  
  //MARK: carousel delegates
  func numberOfItems(in carousel: iCarousel) -> Int {
    return 10
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
    return frame.width - 100.0
  }
  
  func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
    let contactView = ContactSlideView.viewFromNib()
    contactView?.frame = CGRect(x: 50.0,y: 0.0, width: frame.width - 100.0,height: frame.height - 80)
    return contactView!
  }
}
