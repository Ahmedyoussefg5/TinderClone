//
//  ProfileImageButton.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-21.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class ProfileImageButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setTitle("Select Photo", for: .normal)
    setTitleColor(.black, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
    clipsToBounds = true
    layer.cornerRadius = 8
    backgroundColor = .white
    contentMode = .scaleAspectFill
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
