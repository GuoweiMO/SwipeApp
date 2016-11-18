//
//  InfoInputView.swift
//  Swipe
//
//  Created by Guowei Mo on 17/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class InfoInputView: UIView, UITextFieldDelegate {
  
  var textFields: [UITextField]? {
    didSet {
      textFields?.forEach({ (field) in
        field.delegate = self
        field.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
      })
    }
  }
  var labels:[UILabel]?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  func textFieldDidBeginEditing(_ textField: UITextField) {
    setLabel(of: textField, hide: false)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    setLabel(of: textField, hide: true)
    return true
  }
  
  func setLabel(of textField: UITextField, hide: Bool)
  {
    if let index = textFields?.index(of: textField), let label = labels?[index] {
      label.isHidden = hide
    }
  }
  
  func textDidChange(sender: UITextField) {
    if let index = textFields?.index(of: sender), let label = labels?[index] {
      label.isHidden = sender.text == nil || sender.text!.isEmpty
    }
  }
  
}
