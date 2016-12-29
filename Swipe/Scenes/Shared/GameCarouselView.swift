//
//  ImageRollView.swift
//  MPhoto
//
//  Created by Guowei Mo on 21/08/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol GameCarouselViewOutput {
  func didScrollToGame(named name: String, in carousel: GameCarouselView)
}

class GameCarouselView: iCarousel {
  struct Parameters {
    let frameSize: CGSize
    let shouldWrap = true
    
    let backgroundOpaqueAreaHeightToFrameHeight: CGFloat = 0.75
    let backgroundOpaqueAreaColor = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    
    let itemWidth: CGFloat = 144.0
    let itemHeight: CGFloat = 96.0
    
    let centerItemScale: CGFloat = 1.0
    var centerItemOffsetY: CGFloat {
      return floor(frameSize.height * 0.1)
    }
    
    let sideItemFadingOffset: CGFloat = 0.5
    let sideItemScale: CGFloat = 0.45
    let sideItemDisplayedWidthToItemWidth: CGFloat = 0.75
    var sideItemOffsetY: CGFloat {
      return floor((backgroundOpaqueAreaHeightToFrameHeight - 1.0) * 0.5 * frameSize.height)
    }
    
    var distanceBetweenItems: CGFloat {
      let sideItemInset = (sideItemDisplayedWidthToItemWidth - 0.5) * itemWidth * sideItemScale
      return floor(frameSize.width * 0.5 - sideItemInset)
    }
    
    func value(for option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
      switch(option)
      {
      case .wrap:
        return CGFloat(NSNumber(booleanLiteral: shouldWrap).floatValue)
      case .fadeMin:
        return -sideItemFadingOffset
      case .fadeMax:
        return sideItemFadingOffset
      default: return value
      }
    }
  }
  
  var output: GameCarouselViewOutput?
  
  var parameters: Parameters
  var games = []
  var lastNotifiedIndex: Int?
  
  override init(frame: CGRect) {
    parameters = Parameters(frameSize: frame.size)
    
    super.init(frame: frame)
    
    delegate = self
    dataSource = self
    type = .custom
    addBackground()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addBackground() {
    let width = frame.size.width
    let height = parameters.backgroundOpaqueAreaHeightToFrameHeight * frame.size.height
    let opaqueView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
    
    opaqueView.backgroundColor = parameters.backgroundOpaqueAreaColor
    addBottomShadow(to: opaqueView)
    insertSubview(opaqueView, at: 0)
  }
  
  func addBottomShadow(to view: UIView) {
    let layer = view.layer
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOffset = CGSize.zero
    layer.shadowOpacity = 1
    layer.shadowRadius = 2.0
  }
//  
//  func displayGames(_ games: []) {
//    if let games = games {
//      self.games.removeAll()
//      self.games.append(contentsOf: games)
//      
//      reloadData()
//    }
//  }
  
  func scrollToGame(named name: String?) {
    guard let name = name else { return }
    
    for i in 0..<games.count {
      if games[i].name == name {
        scrollToItem(at: i, animated: true)
        return
      }
    }
  }
  
  func currentIndexDidChange(to index: Int) {
    lastNotifiedIndex = index
    output?.didScrollToGame(named: games[index].name, in: self)
  }
}

extension GameCarouselView: iCarouselDataSource {
  
  public func numberOfItems(in carousel: iCarousel) -> Int {
    return games.count
  }
  
  func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
    let itemView = createItemViewOrReuse(view: view)
    itemView.image = games[index].logo
    return itemView
  }
  
  func createItemViewOrReuse(view: UIView?) -> UIImageView {
    if let imageView = view as? UIImageView {
      return imageView
    }
    return createItemView()
  }
  
  func createItemView() -> UIImageView {
    let frame = CGRect(x: 0.0, y: 0.0, width: parameters.itemWidth, height: parameters.itemHeight)
    let imageView = UIImageView(frame: frame)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }
}
  
extension GameCarouselView: iCarouselDelegate {
  func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
    return parameters.value(for: option, withDefault: value)
  }
  
  func carousel(_ carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
    let positionTransform = getPositionTransform(itemOffset: offset, baseTransform: transform)
    return getScaleTransform(itemOffset: offset, baseTransform: positionTransform)
  }
  
  func getPositionTransform(itemOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
    let x = offset * parameters.distanceBetweenItems
    let y = calculateValue(forItemWithOffset: offset,
                           valueOfCenterView: parameters.centerItemOffsetY,
                           valueOfSideView: parameters.sideItemOffsetY)
    return CATransform3DTranslate(transform, x, y, 0.0)
  }
  
  func getScaleTransform(itemOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
    let scale = calculateValue(forItemWithOffset: offset,
                               valueOfCenterView: parameters.centerItemScale,
                               valueOfSideView: parameters.sideItemScale)
    return CATransform3DScale(transform, scale, scale, scale)
  }
  
  func calculateValue(forItemWithOffset offset: CGFloat, valueOfCenterView: CGFloat, valueOfSideView: CGFloat) -> CGFloat {
    let ratio = 1 - abs(offset)
    return ratio * (valueOfCenterView - valueOfSideView) + valueOfSideView
  }
  
  func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
    if lastNotifiedIndex != currentItemIndex {
      currentIndexDidChange(to: currentItemIndex)
    }
  }
}
