//
//  ChangeProfilePicViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 16/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class ChangeProfilePicViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var imageScrollView: UIScrollView!
  @IBOutlet weak var yesButton: SWButton!
  @IBOutlet weak var noButton: SWButton!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var photoButton: UIButton!
  
  var imageView: UIImageView?
  var profileImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageScrollView.minimumZoomScale = 1
    imageScrollView.maximumZoomScale = 6.0
    imageScrollView.delegate = self
    imageScrollView.bounces = false
    imageScrollView.showsVerticalScrollIndicator = false
    imageScrollView.showsHorizontalScrollIndicator = false
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    yesButton.clearStyleWhiteBorder()
    noButton.clearStyleWhiteBorder()
    
    setupBackgroundImage()
  }
  
  private func setupBackgroundImage() {
    if let image = profileImage {
      if imageView == nil {
        imageView = UIImageView()
        imageScrollView.addSubview(imageView!)
      }
      imageView?.image = image
      imageView?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
      imageScrollView.contentSize = image.size
    }
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView!
  }
  
  @IBAction func noButtonDidTap(_ sender: UIButton) {
    
    if sender.currentTitle == "NO" {
      sender.setTitle("X", for: .normal)
    } else {
      sender.setTitle("NO", for: .normal)
    }
    setPhotoButtons(hidden: sender.currentTitle == "NO")
  }
  
  func setPhotoButtons(hidden: Bool) {
    cameraButton.isHidden = hidden
    photoButton.isHidden = hidden
  }
  
}
