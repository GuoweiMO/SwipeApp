//
//  SwipedView.swift
//  Swipe
//
//  Created by Guowei Mo on 27/12/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol SwipedViewOutput {
  func triggerSwipeAction()
  func showHomeCardView()
}

class SwipedView: UIView, CardCarouselViewOutput {

  enum ViewState {
    case normal
    case error
    case swipers
  }
  
  @IBOutlet weak var radarContainer: RadarView!
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var secondsLabel: UILabel!
  @IBOutlet weak var swipeAgainButton: SWButton!
  @IBOutlet weak var myCardButton: SWButton!
  @IBOutlet weak var timeoutErrorLabel: UILabel!
  
  var radarView: RadarView!
  var output: SwipedViewOutput?
  var swipersView: CardCarouselView?
  var avatarsView: AvatarsView?
  
  var timer: Timer?
  
  var state: ViewState = .normal {
    didSet {
      if state == .normal {
        swipeAgainButton.isHidden = true
        myCardButton.isHidden = true
        timeoutErrorLabel.isHidden = true
        swipersView?.isHidden = true
        
        counterLabel.isHidden = false
        secondsLabel.isHidden = false
      }
      else if state == .error {
        swipeAgainButton.isHidden = false
        myCardButton.isHidden = false
        timeoutErrorLabel.isHidden = false
        
        counterLabel.isHidden = true
        secondsLabel.isHidden = true
        swipersView?.isHidden = true
      }
      else if state == .swipers {
        swipeAgainButton.isHidden = true
        myCardButton.isHidden = true
        timeoutErrorLabel.isHidden = true
        counterLabel.isHidden = true
        secondsLabel.isHidden = true
        radarView.isHidden = true
        
        swipersView?.isHidden = false
      }
    }
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    swipeAgainButton.clearStyleWhiteBorder()
    myCardButton.clearStyleWhiteBorder()
    radarView = RadarView.viewFromNib()
    radarView.frame = radarContainer.bounds
    radarContainer.addSubview(radarView)
    radarView.initViews()
    state = .normal
  }
  
  func startCounter() {
    var start = 30
    radarView.start()
    if #available(iOS 10.0, *) {
      timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
        [unowned self] (timer) in
        start -= 1
        self.counterLabel.text = "\(start)"
        if start == 0 {
          self.state = .error
          self.stopCounter()
        }
      }
    } else {
      // Fallback on earlier versions
    }
  }
  
  @IBAction func swipeAgainDidTap(_ sender: Any) {
    state = .normal
    startCounter()
    output?.triggerSwipeAction()
  }
  
  @IBAction func myCardButtonDidTap(_ sender: Any) {
    state = .normal
    output?.showHomeCardView()
  }
  
  func stopCounter(){
    radarView.invalidate()
    timer?.invalidate()
  }
  
  func showSwipersView(withData cards: [SWCard]) {
    if swipersView == nil {
      swipersView = CardCarouselView(frame: self.bounds.insetBy(dx: 30, dy: 80))
      swipersView?.output = self
      addSubview(swipersView!)
    }
    swipersView!.updateView(withCards: cards)
    state = .swipers
    stopCounter()
    
    addAvatarView()
  }
  
  func cardDidSwipeDown(withInfo info: SWCard) {
    if let img = info.smallProfileImage {
      avatarsView!.refreshView(withAvatar: img)
    } else {
      let emptyImage = UIImage()
      let comps = info.fullName.components(separatedBy: " ")
      let shortName = "\(comps.first![comps.first!.startIndex])\(comps.last![comps.first!.startIndex])"
      emptyImage.accessibilityIdentifier = shortName
      avatarsView!.refreshView(withAvatar: emptyImage)
    }
  }
  
  func addAvatarView(){
    if avatarsView == nil {
      avatarsView = AvatarsView(frame: CGRect(x: 20, y: swipersView!.frame.maxY, width: frame.width - 40, height: 80), collectionViewLayout: UICollectionViewLayout())
      addSubview(avatarsView!)
    }
    avatarsView!.reloadData()
  }
  
}
