//
//  HomeViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 18/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

enum ActionState {
  case Normal
  case Swiped
  case None
}

class HomeViewController: UIViewController, LocationHandlerOutput, SwipedViewOutput {
  
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var jobTitleLabel: UILabel!
  @IBOutlet weak var workPlaceLabel: UILabel!
  
  @IBOutlet weak var navBar: UINavigationBar!
  @IBOutlet weak var homeCardView: UIView!
  
  @IBOutlet weak var profilePicView: UIImageView!
  
  var swipedView: SwipedView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    fetchProfileImageOnLoad()
    
    updateNavBarTitleImage(named: "text-logo-red")
    makeNavBarTransparent()
    
    Actions.shared.retrieveMyCard(withCompletion: {
      (dataDict) in
        SWCard.myCard.updateCard(withFullData: dataDict)
        self.updateCardViewWithMyCard()
    }, andError: {
      err in
    })
    
//    SWActions.downloadProfileImage(withName: "profile", completion: {
//      data, error in
//      if data != nil && error == nil {
//        if let image = UIImage(data: data!)
//        {
//          SWActions.getFileMetadata(ofName: "profile", withCompletion: { (data, error) in
//             if let info = data {
//              if info["orientation"] == "portrait" && image.size.width > image.size.height {
//                self.profilePicView.image = image
//                self.profilePicView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
//              }
//              
//            }
//          })
//          
//          self.profilePicView.contentMode = .scaleAspectFill
//          UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
//      }
//    })
    
    swipedView = SwipedView.viewFromNib()
    swipedView.frame = view.bounds
    swipedView.isHidden = true
    swipedView.output = self
    view.insertSubview(swipedView, belowSubview: homeCardView)
    
    homeCardView.isUserInteractionEnabled = true
    let swipeUp = UIPanGestureRecognizer(target: self, action: #selector(homeCardDidSwipe))
    homeCardView.addGestureRecognizer(swipeUp)
    
    LocationHandler.shared.output = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    LocationHandler.shared.startUpdatingLocation()
  }
  
  func fetchProfileImageOnLoad() {
    if SWCard.myCard.largeProfileImage == nil {
      if let image = Common.retrieveImage(fromKeyPath: "largeImage") {
         SWCard.myCard.largeProfileImage = image
      }
    }
    updateProfileImage()
  }
  
  func updateNavBarTitleImage(named name: String) {
    navBar.items?.first?.titleView = UIImageView(image: UIImage(named: name))
  }
  
  func updateProfileImage() {
    profilePicView.image = SWCard.myCard.largeProfileImage
  }
  
  func updateCardViewWithMyCard(){
    fullNameLabel.text = SWCard.myCard.fullName
    jobTitleLabel.text = SWCard.myCard.jobTitle
    workPlaceLabel.text = "at \(SWCard.myCard.employer!)"
  }
  
  func makeNavBarTransparent() {
    navBar.setBackgroundImage(UIImage(), for:.default)
    navBar.shadowImage = UIImage()
    navBar.backgroundColor = UIColor.clear
  }
  
  func homeCardDidSwipe(sender: UIGestureRecognizer) {
    if sender.state == .began {
      let yPoints = view.frame.height
      let velocityY = (sender as! UIPanGestureRecognizer).velocity(in: homeCardView).y
      let duration = abs((yPoints / velocityY) / 3.0)
      var offScreenCenter = homeCardView.center
      
      guard velocityY < -200 else { return}
      
      offScreenCenter.y -= yPoints * 0.8
      swipedView.isHidden = false
      swipedView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      
      UIView.animate(withDuration: Double(duration), animations: {
        self.homeCardView.center = offScreenCenter
        self.homeCardView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.homeCardView.alpha = 0
        
        self.swipedView.alpha = 1
        self.swipedView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.updateNavBarTitleImage(named: "text-logo-white")

      }, completion: { (done) in
        self.homeCardView.isHidden = true
        self.homeCardView.alpha = 1
        self.homeCardView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.swipedView.startCounter()
        self.startQueryingSwipers()
      })
    }
  }
  
  func locationUpdated(to location: Location) {
    SWCard.myCard.location = location
  }
  
  func triggerSwipeAction() {
    startQueryingSwipers()
  }
  
  func startQueryingSwipers() {
    Actions.shared.requestToSendCard(withCompletion: {
      [unowned self] (cnt, swiperList) in
      guard swiperList.count > 0 else { return }
      print(swiperList)
      let cards: [SWCard] = swiperList.map {
        let card = SWCard()
        card.updateCard(withFullData: Array($0!.values)[0])
        return card
      }      
      let keyList: [String] = swiperList.map {
        return Array($0!.keys)[0]
      }
      self.swipedView.showSwipersView(withData: cards, andKeys: keyList)
      
    }, cancelDone: {
      (done) in
      print("no swipers found cancelled")
    })
  }
}
