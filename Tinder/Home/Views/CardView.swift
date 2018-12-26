//
//  CardView.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
  func moreInformationTapped(cardViewModel: CardViewModel)
}

class CardView: UIView {
  
  var delegate: CardViewDelegate?
  
  // MARK: - Views
  
//  private let backgroundImageView: UIImageView = {
//    let imageView = UIImageView()
//    imageView.contentMode = .scaleAspectFill
//    imageView.clipsToBounds = true
//    return imageView
//  }()
  
  let swipingPhotoController = SwipingPhotoController(isCardViewMode: true)
  
  private let gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    gradientLayer.locations = [0.5, 1.1]
    return gradientLayer
  }()
  
  
  private let informationLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    return label
  }()
  
  lazy var informationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleInformationButtonTapped), for: .touchUpInside)
    return button
  }()   
  
  // MARK: - Configuration Constants
  
  fileprivate let panGestureThreshold: CGFloat = 80
  fileprivate let unselectedImageColor = UIColor(white: 0, alpha: 0.1)
  
  // MARK: - View Model
  
  var cardViewModel: CardViewModel! {
    didSet {
      informationLabel.attributedText = cardViewModel.attributedText
      informationLabel.textAlignment = cardViewModel.textAlignment
      swipingPhotoController.imageUrls = cardViewModel.imageUrls
    }
  }
  
  // MARK: - Overrides
  
  override func layoutSubviews() {
    gradientLayer.frame = self.frame
  }
  
  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
    setupGestures()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Setup 
  
  fileprivate func setupSubviews() {
    layer.cornerRadius = 10
    clipsToBounds = true
    
    let swipingView = swipingPhotoController.view!
    addSubview(swipingView)
    swipingView.fillSuperview()
    
    layer.addSublayer(gradientLayer)
    
    addSubview(informationLabel)
    informationLabel.anchor(
      top: nil,
      leading: swipingView.leadingAnchor,
      bottom: swipingView.bottomAnchor,
      trailing: swipingView.trailingAnchor,
      padding: .init(top: 0, left: 20, bottom: 20, right: 20)
    )
    
    addSubview(informationButton)
    informationButton.anchor(
      top: nil,
      leading: nil,
      bottom: bottomAnchor,
      trailing: trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 16, right: 16),
      size: .init(width: 44, height: 44)
    )
  }
  
  fileprivate func setupGestures() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    [panGesture].forEach { addGestureRecognizer($0) }
  }
  
  @objc fileprivate func handleInformationButtonTapped() {
    delegate?.moreInformationTapped(cardViewModel: self.cardViewModel)
  }
  
}

// MARK: - Gestures

extension CardView {
  
  @objc fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      superview?.subviews.forEach { $0.layer.removeAllAnimations() }
    case .changed:
      handlePanGestureChanged(gesture)
    case .ended:
      handlePanGestureEnded(gesture)
    default:
      ()
    }
  }
  
  fileprivate func handlePanGestureChanged(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    let degree = translation.x / 20
    let rotationAngle = degree * .pi / 180
    let rotationalTransformation = CGAffineTransform(rotationAngle: rotationAngle)
    let rotateAndTranslateTransformation = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    transform = rotateAndTranslateTransformation
  }
  
  fileprivate func handlePanGestureEnded(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    let shouldDismissCard = translation.x > panGestureThreshold || translation.x < -panGestureThreshold
    
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

