//
//  ProfileSectionLabel.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-21.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class ProfileSectionLabel: UILabel {
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.insetBy(dx: 16, dy: 0))
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    font = UIFont.systemFont(ofSize: 16, weight: .bold)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
