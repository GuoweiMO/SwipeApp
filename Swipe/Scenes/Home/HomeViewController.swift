//
//  HomeViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 18/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var jobTitleLabel: UILabel!
  @IBOutlet weak var workPlaceLabel: UILabel!
  
  @IBOutlet weak var navBar: UINavigationBar!
  @IBOutlet weak var homeCardView: UIView!
  
  var sendingView: SendingView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    navBar.items?.first?.titleView = UIImageView(image: UIImage(named: "logo-red"))
    navBar.setBackgroundImage(UIImage(), for:.default)
    navBar.shadowImage = UIImage()
    navBar.backgroundColor = UIColor.clear
    
    db.child("cards").child(uid!).observe(.value, with: { (snapshot) in
      if let dataDict = snapshot.value as? [String : AnyObject]
      {
        self.fullNameLabel.text = dataDict["fullName"] as? String
        self.jobTitleLabel.text = dataDict["jobTitle"] as? String
        self.workPlaceLabel.text = dataDict["employer"] as? String
      }
      }) { (err) in }
    
    homeCardView.isUserInteractionEnabled = true
    let swipeUp = UIPanGestureRecognizer(target: self, action: #selector(homeCardDidSwipe))
    homeCardView.addGestureRecognizer(swipeUp)
    
    sendingView = SendingView.viewfromNib() as! SendingView
    sendingView.frame = self.view.bounds
    view.insertSubview(sendingView, belowSubview: homeCardView)
  }
  
  
  func homeCardDidSwipe(sender: UIGestureRecognizer)
  {
    if sender.state == .began
    {
      let yPoints = view.frame.height
      let velocityY = (sender as! UIPanGestureRecognizer).velocity(in: homeCardView).y
      if velocityY < 0
      {
        let duration = abs((yPoints / velocityY) / 2.0)
        var offScreenCenter = homeCardView.center
        offScreenCenter.y -= yPoints * 0.8
        
        UIView.animate(withDuration: Double(duration), animations: {
          self.homeCardView.center = offScreenCenter
          self.homeCardView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
          self.homeCardView.alpha = 0
          }, completion: { (done) in
            self.view.bringSubview(toFront: self.sendingView)
            self.homeCardView.alpha = 1
            self.homeCardView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
      }
    }
  }
}
