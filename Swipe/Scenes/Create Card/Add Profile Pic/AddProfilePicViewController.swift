//
//  AddProfilePicViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 16/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol ImagePickerProtocol: UIImagePickerControllerDelegate, UINavigationControllerDelegate { }

class AddProfilePicViewController: UIViewController, ImagePickerProtocol {
  override func viewDidLoad() {
    super.viewDidLoad()
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
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "create card nav") as? UINavigationController{
        picker.dismiss(animated: true, completion: nil)
        let changeProfileVC = vc.topViewController as! ChangeProfilePicViewController
        changeProfileVC.profileImage = pickedImage
        present(vc, animated: false, completion: nil)
    }
  }

}
 
