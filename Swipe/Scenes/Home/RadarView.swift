//
//  RadarView.swift
//  Swipe
//
//  Created by Guowei Mo on 27/12/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class RadarView: UIView {

  @IBOutlet weak var radar1: UIImageView!
  @IBOutlet weak var radar2: UIImageView!
  @IBOutlet weak var radar3: UIImageView!
  @IBOutlet weak var radar4: UIImageView!
  @IBOutlet weak var radar5: UIImageView!
  
  var radars: [UIImageView]?
  var timer: Timer?
  let overallTimeInterval = 2.5
  
  func initViews() {
    radars = [radar1, radar2, radar3, radar4, radar5]
  }
  
  func start(){
    self.animateRadarView()
    if #available(iOS 10.0, *) {
      timer = Timer.scheduledTimer(withTimeInterval: overallTimeInterval, repeats: true) {
        [unowned self] (timer) in
        self.animateRadarView()
      }
    } else {
      // Fallback on earlier versions
    }
  }
  
  func animateRadarView() {
    for i in 0...4 {
      let interval = overallTimeInterval/Double(radars!.count) * Double(i)
      DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
        print("fired \(i) times")
        self.radars?.forEach({
          [unowned self] (radar) in
          if let index = self.radars?.index(of: radar) {
            radar.isHidden = index > i
          }
        })
      }
    }
  }
  
  func invalidate() {
    timer?.invalidate()
  }
}
