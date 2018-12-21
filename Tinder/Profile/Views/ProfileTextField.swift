//
//  ProfileTextField.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-21.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class ProfileTextField: UITextField {
  
  let padding: CGFloat
  let height: CGFloat
  
  init(padding: CGFloat, height: CGFloat) {
    self.padding = padding
    self.height = height
    super.init(frame: .zero)
    backgroundColor = .white
    layer.cornerRadius = height / 2
  }
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 0, height: height)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
