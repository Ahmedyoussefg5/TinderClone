//
//  RegistrationController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import JGProgressHUD

class RegistrationController: UIViewController {
    
  fileprivate let registrationView = RegistrationView()
  fileprivate let imagePickerController = UIImagePickerController()
  fileprivate let registrationHUD = JGProgressHUD(style: .dark)
  
  fileprivate let registrationViewModel = RegistrationViewModel()
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupObservers()
    setupGestures()
    setupSubviewTargets()
    setupRegistrationViewModelObservers()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    setupObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Setup
  
  fileprivate func setupLayout() {
    view.addSubview(registrationView)
    registrationView.fillSuperview()
  }
  
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
  
  fileprivate func setupSubviewTargets() {
    let fields = [registrationView.fullNameTextfield, registrationView.emailTextfield, registrationView.passwordTextfield]
    fields.forEach { $0.addTarget(self, action: #selector(handleTextChange), for: .editingChanged) }
    registrationView.selectPhotoButton.addTarget(self, action: #selector(handleSelectPhotoTapped), for: .touchUpInside)
    registrationView.registerButton.addTarget(self, action: #selector(handleRegisterTapped), for: .touchUpInside)
  }
  
  fileprivate func setupRegistrationViewModelObservers() {
    registrationViewModel.bindableIsFormValid.bind { [weak self] (isFormValid) in
      guard let self = self else { return }
      guard let isFormValid = isFormValid else { return }
      
      self.registrationView.registerButton.isEnabled = isFormValid
      if isFormValid {
        self.registrationView.registerButton.backgroundColor = #colorLiteral(red: 0.8273344636, green: 0.09256268293, blue: 0.324395299, alpha: 1)
        self.registrationView.registerButton.setTitleColor(.white, for: .normal)
      } else {
        self.registrationView.registerButton.backgroundColor = .gray
        self.registrationView.registerButton.setTitleColor(.darkGray, for: .normal)
      }
    }
    
    registrationViewModel.bindableImage.bind { [weak self] (image) in
      guard let self = self else { return }
      self.registrationView.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    registrationViewModel.bindableIsRegistering.bind { [weak self] (isRegistering) in
      guard let self = self else { return }
      guard let isRegistering = isRegistering else { return }
      if isRegistering {
        self.registrationHUD.textLabel.text = "Registering"
        self.registrationHUD.show(in: self.view)
      } else {
        self.registrationHUD.dismiss()
      }
    }
  }
  
  // MARK: - Registration
  
  @objc fileprivate func handleRegisterTapped() {
    handleTapGesture()
    registrationView.registerButton.isEnabled = false
    registrationViewModel.performRegistration { (error) in
      if let error = error {
        print(error)
        self.showHUDWithError(error)
        self.registrationView.registerButton.isEnabled = true
        self.registrationViewModel.bindableIsRegistering.value = false
      }
      
      print("successfully create user and saved photo to storage")
    }
  }
  
  @objc fileprivate func handleSelectPhotoTapped() {
    imagePickerController.delegate = self
    imagePickerController.isEditing = true
    present(imagePickerController, animated: true)
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
  
  @objc fileprivate func handleKeyboardShow(_ notification: Notification) {
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardHeight = value.cgRectValue.height
    let stackViewY = registrationView.stackView.frame.origin.y
    let stackViewHeight = registrationView.stackView.frame.height
    let bottomSpace = view.frame.height - stackViewY - stackViewHeight
    let difference = keyboardHeight - bottomSpace
    view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
  }
  
  @objc fileprivate func handleKeyboardHide(notification: Notification) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.view.transform = .identity
    })
  }
  
  @objc fileprivate func handleTapGesture() {
    view.endEditing(true)
  }
  
  // MARK: - Helpers
  
  fileprivate func showHUDWithError(_ error: Error) {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Failed Registration"
    hud.detailTextLabel.text = error.localizedDescription
    hud.show(in: view)
    hud.dismiss(afterDelay: 2.5)
  }
  
}

extension RegistrationController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[.originalImage] as? UIImage
    registrationViewModel.bindableImage.value = image
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}
