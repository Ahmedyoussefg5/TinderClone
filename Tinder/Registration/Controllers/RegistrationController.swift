//
//  RegistrationController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
  fileprivate let registrationView = RegistrationView()
  fileprivate let registrationViewModel = RegistrationViewModel()
  
  // MARK: - Overrides
  
  override func loadView() {
    view = registrationView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupObservers()
    setupGestures()
    setupTextFieldTargets()
    setupIsFormValidObserver()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Setup
  
  fileprivate func setupObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleKeyboardShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleKeyboardHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  fileprivate func setupGestures() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
  }
  
  fileprivate func setupTextFieldTargets() {
    let fields = [registrationView.fullNameTextfield, registrationView.emailTextfield, registrationView.passwordTextfield]
    fields.forEach { $0.addTarget(self, action: #selector(handleTextChange), for: .editingChanged) }
  }
  
  fileprivate func setupIsFormValidObserver() {
    registrationViewModel.isFormValidObserver = { [weak self] (isFormValid) in
      guard let self = self else { return }
      self.registrationView.registerButton.isEnabled = isFormValid
      if isFormValid {
        self.registrationView.registerButton.backgroundColor = #colorLiteral(red: 0.8273344636, green: 0.09256268293, blue: 0.324395299, alpha: 1)
        self.registrationView.registerButton.setTitleColor(.white, for: .normal)
      } else {
        self.registrationView.registerButton.backgroundColor = .gray
        self.registrationView.registerButton.setTitleColor(.darkGray, for: .normal)
      }
    }
  }
  
  // MARK: - Keyboard
  
  @objc fileprivate func handleTextChange(textField: UITextField) {
    if textField == registrationView.fullNameTextfield {
      registrationViewModel.fullName = textField.text
    } else if textField == registrationView.emailTextfield {
      registrationViewModel.email = textField.text
    } else {
      registrationViewModel.password = textField.text
    }
  }
  
  @objc fileprivate func handleKeyboardShow(notification: Notification) {
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardFrame = value.cgRectValue
    let stackViewY = registrationView.stackView.frame.origin.y
    let stackViewHeight = registrationView.stackView.frame.height
    let bottomSpace = view.frame.height - stackViewY - stackViewHeight
    let difference = keyboardFrame.height - bottomSpace
    self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
  }
  
  @objc fileprivate func handleKeyboardHide(notification: Notification) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.view.transform = .identity
    })
  }
  
  @objc fileprivate func handleTapGesture(_ gesture: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
}
