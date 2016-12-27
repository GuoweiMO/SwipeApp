//
//  HomeViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 18/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

enum CardViewState {
  case Normal
  case ToSend
  case Sending
  case Sent
  case Receiving
  case Received
  case Else
}

class HomeViewController: UIViewController,
                          SendingViewOutput,
                          ReceivingViewOutput,
                          NumberPadViewOutPut {
  
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var jobTitleLabel: UILabel!
  @IBOutlet weak var workPlaceLabel: UILabel!
  
  @IBOutlet weak var navBar: UINavigationBar!
  @IBOutlet weak var homeCardView: UIView!
  
  @IBOutlet weak var profilePicView: UIImageView!
  
  var sendingView: SendingView!
  var receivingView: ReceivingView!
  var navigationView: NavigationView?
  var numberPadView: NumberPadView?
  
  var state: CardViewState? = .Normal {
    didSet {
      setCardView(toState: state!)
    }
  }
  
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
      let duration = abs((yPoints / velocityY) / 2.0)
      var offScreenCenter = homeCardView.center
      var stateToChange: CardViewState?
      
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
          self.animateNumberPad()
          self.homeCardView.alpha = 1
          self.homeCardView.transform = CGAffineTransform(scaleX: 1, y: 1)
      })
    }
  }
  
  func animateNumberPad() {
    if numberPadView == nil {
      numberPadView = NumberPadView.viewfromNib()
      numberPadView?.frame = view.bounds.insetBy(dx: 30, dy: 80)
      numberPadView?.alpha = 0
      numberPadView?.output = self
      view.addSubview(numberPadView!)
    }

    UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut, animations: {
      self.numberPadView?.alpha = 1
      self.numberPadView?.isHidden = false
    }, completion: nil)
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
  
  func setCardView(toState state:CardViewState)
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
      break
//      SWActions.resetCardWhenFinished(andCompletion: { (err, ref) in
//        self.sendingView.updateViewWhenSent()
//      })
    case .Receiving:
      homeCardView.isHidden = true
      updateNavBarTitleImage(named: "text-logo-white")
    case .Received:
      break
//      SWActions.resetCardWhenFinished(andCompletion: { (err, ref) in
//        self.receivingView.updateViewWhenReceived()
//      })

    default:
      break
    }
  }
  
  func didConfirmNumbers(withNumber token: String) {
    if state == .ToSend {
      didClaimToSendCard(withToken: token)
    }
    else if state == .Receiving {
      didClaimToReceiveCard(withToken: token)
    }
  }
  
  private func didClaimToSendCard(withToken token: String) {
//    SWActions.requestToSendCard(withToken: token, receiverFoundCompletion: {
//      receiver -> Void in
//      let receiverCard = SWCard()
//      if let receiverInfo = receiver.values.first as? [String: Any] {
//        receiverCard.updateCard(withFullData: receiverInfo )
//        self.updateSendingView(withReceiver: receiverCard.fullName)
//      }
//      if let uid = receiver.keys.first {
//        SWActions.downloadProfileImage(withUID: uid, completion: { (data, err) in
//          if data != nil && err == nil {
//            if let image = UIImage(data: data!) {
//              self.updateSendingView(withImage: image)
//            }
//          }
//        })
//      }
//      }, andError: {
//        err in
//    })
  }
  
  private func didClaimToReceiveCard(withToken token: String) {
//    SWActions.requestToReceiveCard(withToken: token, senderFoundCompletion: { (sender) in
//      let senderCard = SWCard()
//      if let senderInfo = sender.values.first as? [String: Any] {
//        senderCard.updateCard(withFullData: senderInfo )
//        self.updateReceivingView(withSender: senderCard.fullName)
//      }
//      if let uid = sender.keys.first {
//        SWActions.downloadProfileImage(withUID: uid, completion: { (data, err) in
//          if data != nil && err == nil {
//            if let image = UIImage(data: data!) {
//              self.updateReceivingView(withImage: image)
//              DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.state = .Received
//              }
//            }
//          }
//        })
//      }
//      
//      
//    }, andError: { (err) in
//      print("sender not found")
//    })
  }

  func updateSendingView(withReceiver senderName: String) {
    sendingView.updateView(withSender: senderName)
  }
  
  func updateSendingView(withImage image: UIImage) {
    sendingView.updateView(withImage: image)
  }

  func updateReceivingView(withSender senderName: String) {
    receivingView.updateView(withSender: senderName)
  }
  
  func updateReceivingView(withImage image: UIImage) {
    receivingView.updateView(withImage: image)
  }
}


extension HomeViewController: NavigationViewDelegate {
  
  @IBAction func navigationBtnDidTap(_ sender: Any) {
    Common.createNavigationIn(viewController: self)
  }
  
  func present(withViewController viewController: UIViewController) {
    if !(viewController is HomeViewController) {
      present(viewController, animated: false, completion: {
        
      })
    }
  }
}
