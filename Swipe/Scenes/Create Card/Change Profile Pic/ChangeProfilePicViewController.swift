//
//  ChangeProfilePicViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 16/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class ChangeProfilePicViewController: UIViewController, ImagePickerProtocol, UIScrollViewDelegate {
  
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
      imageView!.frame = CGRect(x: 0, y: 0, width: image.size.width/2, height: image.size.height/2)
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let outputImage = Common.crop(profileImage!, toRect: view.frame) {
       SWCard.myCard.largeProfileImage = outputImage
    }
  }
  
  func setPhotoButtons(hidden: Bool) {
    cameraButton.isHidden = hidden
    photoButton.isHidden = hidden
  }
  
}
