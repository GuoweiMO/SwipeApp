//
//  ChangeProfilePicViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 16/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class ChangeProfilePicViewController: UIViewController, ImagePickerProtocol, UIScrollViewDelegate{
  
  @IBOutlet weak var imageScrollView: UIScrollView!
  @IBOutlet weak var yesButton: SWButton!
  @IBOutlet weak var noButton: SWButton!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var photoButton: UIButton!
  @IBOutlet weak var circleCropView: UIImageView!

  var imageView: UIImageView?
  var profileImage: UIImage?
  var scale: CGFloat = 1.0
  var overlay: OverLayView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageScrollView.minimumZoomScale = 1
    imageScrollView.maximumZoomScale = 6.0
    imageScrollView.delegate = self
    imageScrollView.bounces = false
    imageScrollView.showsVerticalScrollIndicator = false
    imageScrollView.showsHorizontalScrollIndicator = false
    
    if profileImage != nil {
      setupBackgroundImage()
    }
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    yesButton.clearStyleWhiteBorder()
    noButton.clearStyleWhiteBorder()
  }
  
  private func setupBackgroundImage() {
    if let image = profileImage {
      if imageView == nil {
        imageView = UIImageView()
        imageScrollView.addSubview(imageView!)
      }
      imageView!.image = image
      
      scale = min(image.size.width/imageScrollView.frame.width, image.size.height/imageScrollView.frame.height)
      
      imageView!.frame = CGRect(x: 0, y: 0, width: image.size.width/scale, height: image.size.height/scale)
      imageScrollView.contentSize = imageView!.bounds.size
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
  
  @IBAction func yesButtonDidTap(_ sender: UIButton) {
    if sender.currentTitle == "YES" {
      createCropOverLay()
      sender.setTitle("NEXT", for: .normal)
    } else if sender.currentTitle == "NEXT" {
      saveLargeImage()
      saveSmallImage()
      if let vc = mainStoryBoard.instantiateViewController(withIdentifier: "add info") as? AddInfoViewController {
        navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
  
  func createCropOverLay(){
    
    circleCropView.isHidden = false
    overlay = OverLayView(frame: view.bounds)
    overlay!.circleRect = circleCropView.frame
    view.insertSubview(overlay!, belowSubview: circleCropView)
    
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first,
      circleCropView.bounds.contains(touch.location(in: circleCropView)) {
      let location = touch.location(in: circleCropView.superview)
      circleCropView.center = location
      overlay!.circleRect = circleCropView.frame
      overlay!.setNeedsDisplay()
    }
  }
  
  @IBAction func cameraButtonDidTap(_ sender: Any) {
    let vc = Common.createImagePicker(withType: .camera, andDelegate: self)
    present(vc, animated: true, completion: nil)
  }
  
  @IBAction func photoButtonDidTap(_ sender: Any) {
    let vc = Common.createImagePicker(withType: .photoLibrary, andDelegate: self)
    present(vc, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      picker.dismiss(animated: true, completion: nil)
      profileImage = pickedImage
      setupBackgroundImage()
    }
  }
  
  func saveLargeImage() {
    let visibleRect = CGRect(x: imageScrollView.contentOffset.x * scale,
                              y: imageScrollView.contentOffset.y * scale,
                              width: imageScrollView.frame.width * scale,
                              height: imageScrollView.frame.height * scale)
    if let outputImage = Common.crop(profileImage!, toRect: visibleRect) {
       SWCard.myCard.largeProfileImage = outputImage
    }
  }
  
  func saveSmallImage() {
    let cropRect = CGRect(x: circleCropView.frame.origin.x * scale,
                          y: circleCropView.frame.origin.y * scale,
                          width: circleCropView.frame.size.width * scale,
                          height: circleCropView.frame.size.height * scale)
    
    if let smallImage = Common.crop(SWCard.myCard.largeProfileImage!, toRect: cropRect) {
      SWCard.myCard.smallProfileImage = smallImage
    }
  }
  
  func setPhotoButtons(hidden: Bool) {
    cameraButton.isHidden = hidden
    photoButton.isHidden = hidden
  }
  
}

class OverLayView: UIView {
  var circleRect: CGRect?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    isOpaque = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    if let context = UIGraphicsGetCurrentContext() {
      context.clear(bounds)
      let clipPath = UIBezierPath(rect: bounds)
      let path = UIBezierPath(roundedRect: circleRect!,cornerRadius: circleRect!.width / 2)
      clipPath.append(path)
      clipPath.usesEvenOddFillRule = true
      clipPath.addClip()
      
      UIColor(white: 0, alpha: 0.4).setFill()
      clipPath.fill()
    }

  }
}
