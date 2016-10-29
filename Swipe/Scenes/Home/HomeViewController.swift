//
//  HomeViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 18/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

enum CardState {
  case Normal
  case ToSend
  case Sending
  case Sent
  case Receiving
  case Received
  case Else
}

class HomeViewController: UIViewController, SendingViewOutput,ReceivingViewOutput {
  
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var jobTitleLabel: UILabel!
  @IBOutlet weak var workPlaceLabel: UILabel!
  
  @IBOutlet weak var navBar: UINavigationBar!
  @IBOutlet weak var homeCardView: UIView!
  
  @IBOutlet weak var profilePicView: UIImageView!
  
  var sendingView: SendingView!
  var receivingView: ReceivingView!
  var navigationView: NavigationView?
  
  var state: CardState? = .Normal {
    didSet {
      setCardView(toState: state!)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    updateNavBarTitleImage(named: "text-logo-red")
    navBar.setBackgroundImage(UIImage(), for:.default)
    navBar.shadowImage = UIImage()
    navBar.backgroundColor = UIColor.clear
    
    SWActions.retrieveMyCard(withCompletion: {
      (dataDict) in
        self.fullNameLabel.text = dataDict["fullName"] as? String
        self.jobTitleLabel.text = dataDict["jobTitle"] as? String
        self.workPlaceLabel.text = "at " + (dataDict["employer"] as! String)
    }, andError: {
      err in
    })
    
    SWActions.downloadProfileImage(withName: "profile", completion: {
      data, error in
      if data != nil && error == nil {
        if let image = UIImage(data: data!)
        {
          SWActions.getFileMetadata(ofName: "profile", withCompletion: { (data, error) in
             if let info = data?.customMetadata {
              if info["orientation"] == "portrait" && image.size.width > image.size.height {
                self.profilePicView.image = image
                self.profilePicView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
              }
              
            }
          })
          
          self.profilePicView.contentMode = .scaleAspectFill
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
      }
    })
    
    homeCardView.isUserInteractionEnabled = true
    let swipeUp = UIPanGestureRecognizer(target: self, action: #selector(homeCardDidSwipe))
    homeCardView.addGestureRecognizer(swipeUp)
    
    sendingView = SendingView.viewfromNib()
    sendingView.output = self
    sendingView.alpha = 0
    view.addSubview(sendingView)
    
    receivingView = ReceivingView.viewfromNib()
    receivingView.output = self
    receivingView.alpha = 0
    view.addSubview(receivingView)
    
    view.bringSubview(toFront: navBar)
    state = .Normal
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    sendingView.frame = self.view.bounds

  }
  
  func homeCardDidSwipe(sender: UIGestureRecognizer)
  {
    if sender.state == .began
    {
      let yPoints = view.frame.height
      let velocityY = (sender as! UIPanGestureRecognizer).velocity(in: homeCardView).y
      let duration = abs((yPoints / velocityY) / 2.0)
      var offScreenCenter = homeCardView.center
      var stateToChange: CardState?
      
      guard velocityY < -200 || velocityY > 200 else { return}
      
      if velocityY < -200
      {
        offScreenCenter.y -= yPoints * 0.8
        stateToChange = .ToSend
        sendingView.isHidden = false
        sendingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      }
      else if velocityY > 200
      {
        offScreenCenter.y += yPoints * 0.8
        stateToChange = .Receiving
        receivingView.isHidden = false
        receivingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

      }

      UIView.animate(withDuration: Double(duration), animations: {
        self.homeCardView.center = offScreenCenter
        self.homeCardView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.homeCardView.alpha = 0
        
        if stateToChange == .ToSend
        {
          self.sendingView.alpha = 1
          self.sendingView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        else if stateToChange == .Receiving
        {
          self.receivingView.alpha = 1
          self.receivingView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        }, completion: { (done) in
          self.state = stateToChange
          self.homeCardView.alpha = 1
          self.homeCardView.transform = CGAffineTransform(scaleX: 1, y: 1)
      })
    }
  }
  
  func moveSendingViewToFront()
  {
    view.bringSubview(toFront: sendingView)
  }
  
  func refreshHomeView()
  {
    
  }
  
  func userDidConfirmSending() {
    state = .Sending
    //TODO: make sending request
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      self.state = .Sent
    }
  }
  
  func cardSentNavigateToHome() {
    state = .Normal
  }
  
  func cardReceivedNavigateToHome() {
    state = .Normal
  }
  
  func setCardView(toState state:CardState)
  {
    switch state {
    case .Normal:
      
      homeCardView.isHidden = false
      updateNavBarTitleImage(named: "text-logo-red")

      sendingView.isHidden = true
      receivingView.isHidden = true
      
      sendingView.resetView()
      receivingView.resetView()
      
      refreshHomeView()
      
    case .ToSend:
      
      homeCardView.isHidden = true
      updateNavBarTitleImage(named: "text-logo-white")
      sendingView.resetView()
      
    case .Sending:
      sendingView.updateViewAtSending()
    case .Sent:
      sendingView.updateViewWhenSent()
      
    case .Receiving:
      homeCardView.isHidden = true
      updateNavBarTitleImage(named: "text-logo-white")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        self.state = .Received
      }
    case .Received:
      receivingView.updateViewWhenReceived()

    default:
      break
    }
  }
  
  func updateNavBarTitleImage(named name: String)
  {
    navBar.items?.first?.titleView = UIImageView(image: UIImage(named: name))
  }
  
  @IBAction func navigationBtnDidTap(_ sender: Any) {
    let navView = NavigationView.viewFromNib()
    view.addSubview(navView!)
    navView!.frame = view.bounds
    navView!.buttonsContainerView.frame.origin.y -= navView!.frame.size.height - 60
    
    UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut, animations: {
      navView!.buttonsContainerView.frame.origin.y = 60
    }, completion: nil)
  }
  
  
}
