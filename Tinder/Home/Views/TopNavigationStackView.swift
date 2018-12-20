//
//  TopNavigationStackView.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
  
  // MARK: - Subviews
  
  let profileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let logoImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "app_icon")!)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  let messagesButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    distribution = .equalCentering
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    heightAnchor.constraint(equalToConstant: 80).isActive = true
    
    let arrangedSubviews = [
      profileButton, UIView(), logoImageView, UIView(), messagesButton
    ]
    
    arrangedSubviews.forEach { addArrangedSubview($0) }
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

