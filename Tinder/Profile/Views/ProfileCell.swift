//
//  ProfileCell.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-21.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
  
  let textField: ProfileTextField = {
    let tf = ProfileTextField(padding: 16, height: 44)
    return tf
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(textField)
    textField.fillSuperview()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
