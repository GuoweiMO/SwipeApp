//
//  AddProfilePicView.swift
//  Swipe
//
//  Created by Guowei Mo on 20/10/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol AddProfilePicOutput: class {
  func present(imagePicker: UIImagePickerController)
  func imagePicker(imagePicker: UIImagePickerController, didSelectImage image:UIImage)
}

class AddProfilePicView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var takePhotoBtn: SWButton!
  @IBOutlet weak var choosePhotoBtn: SWButton!
  var imagePicker: UIImagePickerController?
  weak var output: AddProfilePicOutput?
  class func viewFromNib() -> AddProfilePicView?
  {
    return Bundle.main.loadNibNamed("AddProfilePicView", owner: self, options: nil)?.first as? AddProfilePicView
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clear
  }
  
  override func draw(_ rect: CGRect) {
    takePhotoBtn.redStyle()
    choosePhotoBtn.redStyle()
  }

  
  @IBAction func takePhotoBtnDidTap(_ sender: AnyObject) {
    createPhotoPicker(with: .camera)
  }
  
  @IBAction func choosePhotoBtnDidTap(_ sender: AnyObject) {
    createPhotoPicker(with: .photoLibrary)
  }
  
  func createPhotoPicker(with type: UIImagePickerControllerSourceType)
  {
    if imagePicker == nil
    {
      imagePicker = UIImagePickerController()
      imagePicker?.allowsEditing = true
      imagePicker?.delegate = self
    }
    imagePicker!.sourceType = type
    output?.present(imagePicker: imagePicker!)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      output?.imagePicker(imagePicker: picker, didSelectImage: pickedImage)
    }
  }
  
}
