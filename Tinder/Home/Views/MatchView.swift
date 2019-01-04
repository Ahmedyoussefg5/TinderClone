//
//  MatchView.swift
//  Tinder
//
//  Created by Jason Ngo on 2019-01-03.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MatchView: UIView {

  let blurEffectView: UIVisualEffectView = {
    let effect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    effect.alpha = 0
    return effect
  }()
  
  let itsAMatchImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch").withRenderingMode(.alwaysOriginal))
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 20, weight: .light)
    label.textColor = .white
    label.text = "You and X have liked each other"
    return label
  }()
  
  let currentUserImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal))
    iv.contentMode = .scaleAspectFill
    iv.layer.cornerRadius = 140 / 2
    iv.layer.borderColor = UIColor.white.cgColor
    iv.layer.borderWidth = 2
    iv.clipsToBounds = true
    return iv
  }()
  
  let matchedUserImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal))
    iv.contentMode = .scaleAspectFill
    iv.layer.cornerRadius = 140 / 2
    iv.layer.borderColor = UIColor.white.cgColor
    iv.layer.borderWidth = 2
    iv.clipsToBounds = true
    return iv
  }()
  
  let sendMessageButton: SendMessageButton = {
    let button = SendMessageButton(type: .system)
    button.setTitle("SEND MESSAGE", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  let keepSwipingButton: KeepSwipingButton = {
    let button = KeepSwipingButton(type: .system)
    button.setTitle("Keep Swiping", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  lazy var views: [UIView] = [
    self.itsAMatchImageView,
    self.descriptionLabel,
    self.currentUserImageView,
    self.matchedUserImageView,
    self.sendMessageButton,
    self.keepSwipingButton
  ]
  
  var currentUser: User?
  
  var cardUid: String! {
    didSet {
      let query = Firestore.firestore().collection("users")
      query.document(cardUid).getDocument { (snapshot, error) in
        if let error = error {
          print("Failed to fetch card user", error)
          return
        }
        
        guard let dictionary = snapshot?.data() else { return }
        let user = User(dictionary: dictionary)
        guard let url = URL(string: user.imageUrl1 ?? "") else { return }
        self.matchedUserImageView.sd_setImage(with: url)

        guard let currentUserUrl = URL(string: self.currentUser?.imageUrl1 ?? "") else { return }
        self.currentUserImageView.sd_setImage(with: currentUserUrl, completed: { (_, _, _, _) in
          self.setupAnimations()
        })
        
        self.descriptionLabel.text = "You and \(user.fullName ?? "") have liked\neach other"
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupBlurView()
    setupSubviews()
  }

  fileprivate func setupBlurView() {
    addSubview(blurEffectView)
    blurEffectView.fillSuperview()
    blurEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.blurEffectView.alpha = 1
    })
  }
  
  fileprivate func setupSubviews() {
    views.forEach {
      addSubview($0)
      $0.alpha = 0
    }

    itsAMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    itsAMatchImageView.anchor(
      top: nil,
      leading: nil,
      bottom: descriptionLabel.topAnchor,
      trailing: nil,
      padding: .init(top: 0, left: 0, bottom: 16, right: 0),
      size: .init(width: 300, height: 80)
    )
    
    descriptionLabel.anchor(
      top: nil,
      leading: leadingAnchor,
      bottom: currentUserImageView.topAnchor,
      trailing: trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 32, right: 0),
      size: .init(width: 0, height: 50)
    )
    
    currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    currentUserImageView.anchor(
      top: nil,
      leading: nil,
      bottom: nil,
      trailing: centerXAnchor,
      padding: .init(top: 0, left: 0, bottom: 0, right: 16),
      size: .init(width: 140, height: 140)
    )
    
    matchedUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    matchedUserImageView.anchor(
      top: nil,
      leading: centerXAnchor,
      bottom: nil,
      trailing: nil,
      padding: .init(top: 0, left: 16, bottom: 0, right: 0),
      size: .init(width: 140, height: 140)
    )
    
    sendMessageButton.anchor(
      top: currentUserImageView.bottomAnchor,
      leading: leadingAnchor,
      bottom: nil,
      trailing: trailingAnchor,
      padding: .init(top: 32, left: 48, bottom: 0, right: 48),
      size: .init(width: 0, height: 60)
    )
    
    keepSwipingButton.anchor(
      top: sendMessageButton.bottomAnchor,
      leading: leadingAnchor,
      bottom: nil,
      trailing: trailingAnchor,
      padding: .init(top: 16, left: 48, bottom: 0, right: 48),
      size: .init(width: 0, height: 60)
    )
  }
  
  fileprivate func setupAnimations() {
    views.forEach { $0.alpha = 1 }
    let angle = 30 * CGFloat.pi / 180
    
    currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(
      CGAffineTransform(translationX: 200, y: 0)
    )
    matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(
      CGAffineTransform(translationX: -200, y: 0)
    )
    sendMessageButton.transform = CGAffineTransform.init(translationX: -500, y: 0)
    keepSwipingButton.transform = CGAffineTransform.init(translationX: 500, y: 0)
    
    UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: .calculationModeCubic, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.35, animations: {
        self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
        self.matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle)
      })
      
      UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.4, animations: {
        self.currentUserImageView.transform = .identity
        self.matchedUserImageView.transform = .identity
      })
    })
    
    UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
      self.sendMessageButton.transform = .identity
      self.keepSwipingButton.transform = .identity
    })
  }
  
  @objc fileprivate func handleTapDismiss() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.alpha = 0
    }) { (_) in
      self.removeFromSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
