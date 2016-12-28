//
//  SwipedView.swift
//  Swipe
//
//  Created by Guowei Mo on 27/12/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol SwipedViewOutput {
  func swipedTimeout()
}

class SwipedView: UIView {

  @IBOutlet weak var radarContainer: RadarView!
  @IBOutlet weak var counterLabel: UILabel!
  var radarView: RadarView!
  var output: SwipedViewOutput?

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    radarView = RadarView.viewFromNib()
    radarView.frame = radarContainer.bounds
    radarContainer.addSubview(radarView)
    radarView.initViews()
  }
  
  func startCounter() {
    var start = 30
    radarView.start()
    if #available(iOS 10.0, *) {
      Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
        [unowned self] (timer) in
        start -= 1
        self.counterLabel.text = "\(start)"
        if start == 0 {
          timer.invalidate()
          self.radarView.invalidate()
          self.output?.swipedTimeout()
        }
      }
    } else {
      // Fallback on earlier versions
    }
  }
  
}
