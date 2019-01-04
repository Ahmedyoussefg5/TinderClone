//
//  KeepSwipingButton.swift
//  Tinder
//
//  Created by Jason Ngo on 2019-01-04.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class KeepSwipingButton: UIButton {

    override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      layer.cornerRadius = rect.height / 2
      clipsToBounds = true
      
      let gradient = CAGradientLayer()
      gradient.frame = rect
      gradient.colors = [#colorLiteral(red: 0.9912214875, green: 0.1260480583, blue: 0.4532288909, alpha: 1).cgColor, #colorLiteral(red: 0.9862181544, green: 0.39221102, blue: 0.3256564736, alpha: 1).cgColor]
      
      let shape = CAShapeLayer()
      shape.lineWidth = 3
      shape.path = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).cgPath
      shape.strokeColor = UIColor.black.cgColor
      shape.fillColor = UIColor.clear.cgColor
      gradient.mask = shape
      
      self.layer.addSublayer(gradient)
    }

}
