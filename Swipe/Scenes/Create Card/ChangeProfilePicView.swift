//
//  ChangeProfilePicView.swift
//  Swipe
//
//  Created by Guowei Mo on 20/10/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol ChangeProfilePicOutput: class {
  func navigateBackToAddProfileView()
  func navigateToUserInfoView()
}

class ChangeProfilePicView: UIView {
 
  @IBOutlet weak var confirmPicBtn: SWButton!
  @IBOutlet weak var chooseNewPhotoBtn: SWButton!
  var output: ChangeProfilePicOutput?
  class func viewFromNib() -> ChangeProfilePicView?
  {
    return Bundle.main.loadNibNamed("ChangeProfilePicView", owner: self, options: nil)?.first as? ChangeProfilePicView
  }
  
  override func draw(_ rect: CGRect) {
    confirmPicBtn.whiteStyleNoBorder()
    chooseNewPhotoBtn.clearStyleWhiteBorder()
  }
  
  @IBAction func confirmPicBtnDidTap(_ sender: AnyObject){
    output?.navigateToUserInfoView()
  }
  
  @IBAction func chooseAnotherPhotoBtnDidTap(_ sender: AnyObject) {
    output?.navigateBackToAddProfileView()
  }
  
}
