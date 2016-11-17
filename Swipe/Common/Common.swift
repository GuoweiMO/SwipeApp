//
//  Common.swift
//  Swipe
//
//  Created by Guowei Mo on 18/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import Foundation
import UIKit

class Common: NSObject {
  
  class func appRedColor() -> UIColor
  {
    return UIColor(red: 1, green: 0, blue: 33.0 / 255.0 , alpha: 1)
  }
  
  
  class func createNavigationIn<T: UIViewController> (viewController: T) where T: NavigationViewDelegate {
    let navView = NavigationView.viewFromNib()
    viewController.view.addSubview(navView!)
    navView!.frame = viewController.view.bounds
    navView!.buttonsContainerView.frame.origin.y -= navView!.frame.size.height - 60
    navView?.delegate = viewController
    
    UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut, animations: {
      navView!.buttonsContainerView.frame.origin.y = 60
    }, completion: nil)
  }
  
  class func crop(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
    if let imageRef = image.cgImage?.cropping(to: rect) {
      return UIImage(cgImage: imageRef)
    }
    return nil
  }
  
  class func createImagePicker(withType type: UIImagePickerControllerSourceType, andDelegate delegate: ImagePickerProtocol) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.delegate = delegate
    imagePicker.sourceType = type
    return imagePicker
  }
}
