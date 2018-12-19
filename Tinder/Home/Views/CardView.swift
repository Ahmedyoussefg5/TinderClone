//
//  CardView.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class CardView: UIView {
  
  // MARK: - Views
  
  let backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c").withRenderingMode(.alwaysOriginal))
    return imageView
  }()
  
  // MARK: - Configuration Constants
  fileprivate let panGestureThreshold: CGFloat = 80

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
      handleChangedPanGesture(gesture)
    case .ended:
      handleEndedPanGesture(gesture)
    default:
      ()
    }
  }
  
  fileprivate func handleChangedPanGesture(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    let degree = translation.x / 20
    let rotationAngle = degree * .pi / 180
    let rotationalTransformation = CGAffineTransform(rotationAngle: rotationAngle)
    let rotateAndTranslateTransformation = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    transform = rotateAndTranslateTransformation
  }
  
  fileprivate func handleEndedPanGesture(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    let shouldDismissCard = translation.x > panGestureThreshold ||
                            translation.x < -panGestureThreshold
    
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
      if shouldDismissCard {
        if translation.x > 0 {
          self.frame = CGRect(x: 1000, y: 0, width: self.frame.width, height: self.frame.height)
        } else {
          self.frame = CGRect(x: -1000, y: 0, width: self.frame.width, height: self.frame.height)
        }
      } else {
        self.transform = .identity
      }
    }) { (_) in
      self.transform = .identity
      self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
    }
  }
  
}
