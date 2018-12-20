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
  
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c").withRenderingMode(.alwaysOriginal))
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let informationLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    return label
  }()
  
  // MARK: - View Model
  
  var cardViewModel: CardViewModel! {
    didSet {
      informationLabel.attributedText = cardViewModel.attributedText
      informationLabel.textAlignment = cardViewModel.textAlignment
      guard let image = UIImage(named: cardViewModel.imageName) else { return }
      backgroundImageView.image = image
    }
  }
  
  // MARK: - Configuration Constants
  
  fileprivate let panGestureThreshold: CGFloat = 80
  
  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.cornerRadius = 10
    clipsToBounds = true
    
    setupSubviews()
    setupGestures()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Setup 
  
  fileprivate func setupSubviews() {
    addSubview(backgroundImageView)
    backgroundImageView.fillSuperview()
    
    addSubview(informationLabel)
    informationLabel.anchor(
      top: nil,
      leading: backgroundImageView.leadingAnchor,
      bottom: backgroundImageView.bottomAnchor,
      trailing: backgroundImageView.trailingAnchor,
      padding: .init(top: 0, left: 20, bottom: 20, right: 20)
    )
  }
  
  fileprivate func setupGestures() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    addGestureRecognizer(panGesture)
  }
  
}

// MARK: - Gestures
extension CardView {
  
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
      if shouldDismissCard {
        self.removeFromSuperview()
      }
    }
  }
  
}
