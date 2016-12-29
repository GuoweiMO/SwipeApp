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
}

class SwipedView: UIView {

  enum ViewState {
    case normal
    case error
    case swipers
  }
  
  @IBOutlet weak var radarContainer: RadarView!
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var secondsLabel: UILabel!
  @IBOutlet weak var swipeAgainButton: SWButton!
  @IBOutlet weak var timeoutErrorLabel: UILabel!
  
  var radarView: RadarView!
  var output: SwipedViewOutput?
  var swipersView: CardCarouselView?
  var timer: Timer?
  
  var state: ViewState = .normal {
    didSet {
      if state == .normal {
        swipeAgainButton.isHidden = true
        timeoutErrorLabel.isHidden = true
        swipersView?.isHidden = true
        
        counterLabel.isHidden = false
        secondsLabel.isHidden = false
      }
      else if state == .error {
        swipeAgainButton.isHidden = false
        timeoutErrorLabel.isHidden = false
        
        counterLabel.isHidden = true
        secondsLabel.isHidden = true
        swipersView?.isHidden = true
      }
      else if state == .swipers {
        swipeAgainButton.isHidden = true
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
  
  func stopCounter(){
    radarView.invalidate()
    timer?.invalidate()
  }
  
  func showSwipersView() {
    if swipersView == nil {
      swipersView = CardCarouselView(frame: self.bounds.insetBy(dx: 30, dy: 80))
      addSubview(swipersView!)
    }
    swipersView!.reloadData()
    state = .swipers
    stopCounter()
  }
}
