//
//  BaseView.swift
//  Swipe
//
//  Created by Guowei Mo on 20/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
  static func viewFromNib() -> Self {
    let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
    return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! Self
  }
  
}

