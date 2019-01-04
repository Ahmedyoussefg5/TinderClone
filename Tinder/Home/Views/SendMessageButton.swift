//
//  SendMessageButton.swift
//  Tinder
//
//  Created by Jason Ngo on 2019-01-03.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let gradientLayer = CAGradientLayer()
    let leftColor = #colorLiteral(red: 0.9912214875, green: 0.1260480583, blue: 0.4532288909, alpha: 1).cgColor
    let rightColor = #colorLiteral(red: 0.9862181544, green: 0.39221102, blue: 0.3256564736, alpha: 1).cgColor
    
    gradientLayer.colors = [leftColor, rightColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    gradientLayer.frame = self.bounds
    
    self.layer.insertSublayer(gradientLayer, at: 0)
    layer.cornerRadius = rect.height / 2
    clipsToBounds = true
  }

}
