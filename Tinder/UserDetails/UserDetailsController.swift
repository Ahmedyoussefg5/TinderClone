//
//  UserDetailsController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class UserDetailsController: UIViewController {
  
  let blurView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: .regular)
    let blurView = UIVisualEffectView(effect: blur)
    return blurView
  }()
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.delegate = self
    return scrollView
  }()
  
  let swipingPhotoController = SwipingPhotoController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal,
    options: nil
  )
  
  let dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
    button.clipsToBounds = true
    return button
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .black
    label.text = "Testing label"
    return label
  }()
  
  let nopeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let likeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let superLikeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  lazy var bottomButtonsStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [
      nopeButton, superLikeButton, likeButton
      ])
    sv.axis = .horizontal
    sv.distribution = .fillEqually
    sv.spacing = -48
    return sv
  }()
  
  // MARK: - ViewModel
  
  var cardViewModel: CardViewModel? {
    didSet {
      descriptionLabel.attributedText = cardViewModel?.attributedText
      swipingPhotoController.imageUrls = cardViewModel?.imageUrls
    }
  }
  
  let extraHeight: CGFloat = 80
  
  // MARK: - Overrides
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let imageView = swipingPhotoController.view!
    imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraHeight)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
  }
  
  fileprivate func setupLayout() {
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.fillSuperview()
    
    let swipingView = swipingPhotoController.view!
    
    scrollView.addSubview(swipingView)
    swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    
    scrollView.addSubview(dismissButton)
    dismissButton.anchor(
      top: swipingView.bottomAnchor,
      leading: nil,
      bottom: nil,
      trailing: view.trailingAnchor,
      padding: .init(top: -22, left: 0, bottom: 0, right: 22),
      size: .init(width: 44, height: 44)
    )
    dismissButton.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
    
    scrollView.addSubview(descriptionLabel)
    descriptionLabel.anchor(
      top: swipingView.bottomAnchor,
      leading: scrollView.leadingAnchor,
      bottom: nil,
      trailing: scrollView.trailingAnchor,
      padding: .init(top: 16, left: 16, bottom: 0, right: 16)
    )
    
    scrollView.addSubview(bottomButtonsStackView)
    bottomButtonsStackView.anchor(
      top: nil,
      leading: nil,
      bottom: view.safeAreaLayoutGuide.bottomAnchor,
      trailing: nil,
      padding: .init(top: 0, left: 0, bottom: 0, right: 0),
      size: .init(width: 300, height: 120)
    )
    bottomButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    view.addSubview(blurView)
    blurView.anchor(
      top: view.topAnchor,
      leading: view.leadingAnchor,
      bottom: view.safeAreaLayoutGuide.topAnchor,
      trailing: view.trailingAnchor
    )
  }
  
  @objc fileprivate func handleDismissTapped() {
    dismiss(animated: true, completion: nil)
  }
  
}

extension UserDetailsController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let changeY = -scrollView.contentOffset.y
    let width = max(view.frame.width, (view.frame.width + (changeY * 2)))
    let x = min(0, -changeY)
    let swipingView = swipingPhotoController.view!
    swipingView.frame = CGRect(x: x, y: x, width: width, height: width + extraHeight)
  }
}
