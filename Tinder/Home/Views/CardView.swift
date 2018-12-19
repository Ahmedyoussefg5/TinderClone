//
//  CardView.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class CardView: UIView {
  
  let backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c").withRenderingMode(.alwaysOriginal))
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.cornerRadius = 10
    clipsToBounds = true
    
    addSubview(backgroundImageView)
    backgroundImageView.fillSuperview()
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    addGestureRecognizer(panGesture)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .changed:
      handleChangedPanGesture(gesture: gesture)
    case .ended:
      handleEndedPanGesture()
    default:
      ()
    }
  }
  
  fileprivate func handleChangedPanGesture(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    transform = CGAffineTransform(translationX: translation.x, y: translation.y)
  }
  
  fileprivate func handleEndedPanGesture() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
      self.transform = .identity
    })
  }
  
}
