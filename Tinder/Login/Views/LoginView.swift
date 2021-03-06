//
//  LoginView.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

final class LoginView: UIView {
  
  private let gradientLayer = CAGradientLayer()
  private lazy var stackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [
      emailTextField,
      passwordTextField,
      loginButton
      ])
    sv.spacing = 8
    sv.axis = .vertical
    return sv
  }()
  
  // MARK: - Stackview subviews
  
  let emailTextField: RegistrationTextField = {
    let tf = RegistrationTextField(padding: 24, height: 44)
    tf.placeholder = "Enter email"
    tf.keyboardType = .emailAddress
    return tf
  }()
  
  let passwordTextField: RegistrationTextField = {
    let tf = RegistrationTextField(padding: 24, height: 44)
    tf.placeholder = "Enter password"
    tf.isSecureTextEntry = true
    return tf
  }()
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    button.titleLabel?.textAlignment = .center
    button.backgroundColor = .gray
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    button.layer.cornerRadius = 22
    button.isEnabled = false
    return button
  }()
  
  // MARK: - Registration
  
  let goToRegistrationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Go to Registration", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    return button
  }()
  
  // MARK: - Overrides
  
  override func layoutSubviews() {
    gradientLayer.frame = self.frame
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupGradientLayer()
    setupSubviews()
  }
  
  // MARK: - Setup
  
  private func setupGradientLayer() {
    gradientLayer.colors = [#colorLiteral(red: 0.8971258998, green: 0.1223937199, blue: 0.4557680488, alpha: 1).cgColor, #colorLiteral(red: 0.9893690944, green: 0.3603764176, blue: 0.3745168447, alpha: 1).cgColor]
    gradientLayer.locations = [0, 1]
    layer.addSublayer(gradientLayer)
  }
  
  private func setupSubviews() {
    addSubview(stackView)
    stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    stackView.anchor(
      top: nil,
      leading: leadingAnchor,
      bottom: nil,
      trailing: trailingAnchor,
      padding: .init(top: 0, left: 50, bottom: 0, right: 50)
    )
    
    addSubview(goToRegistrationButton)
    goToRegistrationButton.anchor(
      top: nil,
      leading: leadingAnchor,
      bottom: safeAreaLayoutGuide.bottomAnchor,
      trailing: trailingAnchor
    )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

