//
//  ContactsCarouselView.swift
//  Swipe
//
//  Created by Guowei Mo on 07/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol CardCarouselViewOutput {
  func cardDidSwipeDown(withInfo info: SWCard)
}

var likedCards = NSMutableArray()

class CardCarouselView: iCarousel, iCarouselDelegate, iCarouselDataSource {
  
  var cardItems = NSMutableArray()
//  var cardKeys: [String] = []
  var output: CardCarouselViewOutput?
  
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
  
  //MARK: carousel delegates
  func numberOfItems(in carousel: iCarousel) -> Int {
    return cardItems.count
  }
  
  func updateView(withCards cards:[SWCard]){
    cardItems.removeAllObjects()
    cardItems.addObjects(from: cards)
//    cardKeys = keys
    if likedCards.count > 0 {
      likedCards.forEach({ (cardA) in
        cardItems.forEach({ (cardB) in
          if (cardA as! SWCard).uid == (cardB as! SWCard).uid {
            cardItems.remove(cardB)
          }
         })
      })
    }
    
    reloadData()
  }
  
  func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
    switch(option)
    {
      case .spacing:
        return value * 1.1
      default:
        return value
    }
  }
  
  func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
    return frame.width - 100.0
  }
  
  func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
    let selectedCard = cardItems[index] as! SWCard
    let cardView = LargeCardView.viewFromNib()
    cardView.frame = CGRect(x: 50.0,y: 0.0, width: frame.width - 100.0,height: frame.height - 80)
    cardView.updateView(withCard: selectedCard)
    if let cachedImg = Common.retrieveImage(fromKeyPath: selectedCard.uid!) {
      cardView.profilePicView.image = cachedImg
      selectedCard.smallProfileImage = cachedImg
    } else {
      Storage.shared.downloadProfileImage(withUID: selectedCard.uid!, completion: { (data, err) in
        guard let data = data else { return }
        if let img = UIImage(data: data) {
          cardView.profilePicView.image = img
          Common.saveImage(image: img, toKeyPath: selectedCard.uid!)
        }
      })
    }
    let ges = UIPanGestureRecognizer(target: self, action: #selector(CardCarouselView.viewPanned))
    cardView.addGestureRecognizer(ges)
    return cardView
  }
  
  func viewPanned(ges: UIPanGestureRecognizer) {
    if ges.state == .began {
      guard let cardView = ges.view else { return }
      let yPoints = frame.height
      let velocityY = ges.velocity(in: ges.view).y
      let duration = abs((yPoints / velocityY) / 1.5)
      var offScreenCenter = ges.view!.center
      
      guard velocityY > 100 else { return}
      offScreenCenter.y += yPoints * 0.8
      
      UIView.animate(withDuration: Double(duration), animations: {
        cardView.center = offScreenCenter
        cardView.alpha = 0
      }, completion: {
        [unowned self] (done) in
        cardView.isHidden = true
        cardView.alpha = 1
        
        likedCards.add(self.cardItems[self.currentItemIndex])
        
        self.output?.cardDidSwipeDown(withInfo: self.cardItems[self.currentItemIndex] as! SWCard)
        self.removeItem(at: self.currentItemIndex, animated: true)
      })
    }
  }
  
}
