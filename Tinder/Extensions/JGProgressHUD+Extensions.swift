//
//  JGProgressHUD+Extensions.swift
//  Tinder
//
//  Created by Jason Ngo on 2019-01-15.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import JGProgressHUD

extension JGProgressHUD {
  
  static func errorHUD(with text: String, error: Error) -> JGProgressHUD {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = text
    hud.detailTextLabel.text = error.localizedDescription
    return hud
  }
  
}
