//
//  RegistrationController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import JGProgressHUD

final class RegistrationController: UIViewController {
    
  private let registrationView = RegistrationView()
  private let registrationViewModel = RegistrationViewModel()
  
  private let imagePickerController = UIImagePickerController()
  private let registrationHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Registering"
    return hud
  }()
  
  var delegate: RegisterAndLoginDelegate?
  
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
    super.viewWillAppear(animated)
    setupObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Setup
  
  private func setupLayout() {
    view.addSubview(registrationView)
    registrationView.fillSuperview()
    navigationController?.isNavigationBarHidden = true
  }
  
  private func setupObservers() {
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
  
  private func setupGestures() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
  }
  
  private func setupSubviewTargets() {
    let fields = [registrationView.fullNameTextfield, registrationView.emailTextfield, registrationView.passwordTextfield]
    fields.forEach { $0.addTarget(self, action: #selector(handleTextChange), for: .editingChanged) }
    registrationView.selectPhotoButton.addTarget(self, action: #selector(handleSelectPhotoTapped), for: .touchUpInside)
    registrationView.registerButton.addTarget(self, action: #selector(handleRegisterTapped), for: .touchUpInside)
    registrationView.goToLoginButton.addTarget(self, action: #selector(handleGoToLoginTapped), for: .touchUpInside)
  }
  
  private func setupRegistrationViewModelObservers() {
    registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
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
    
    registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
      guard let isRegistering = isRegistering else { return }
      
      if isRegistering {
        self.registrationHUD.show(in: self.view)
      } else {
        self.registrationHUD.dismiss()
      }
    }
  }
  
  // MARK: - Registration
  
  @objc private func handleRegisterTapped() {
    handleTapGesture()
    registrationView.registerButton.isEnabled = false
    
    registrationViewModel.performRegistration { [unowned self] (error) in
      if let error = error {
        print(error)
        
        let hud = JGProgressHUD.errorHUD(with: "Failed to register", error: error)
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.5)
        
        self.registrationView.registerButton.isEnabled = true
        return
      }
      
      print("successfully create user and saved photo to storage")
      self.dismiss(animated: true, completion: {
        self.delegate?.userLoggedIn()
      })
    }
  }
  
  @objc private func handleSelectPhotoTapped() {
    imagePickerController.delegate = self
    imagePickerController.isEditing = true
    present(imagePickerController, animated: true)
  }
  
  // MARK: - Keyboard
  
  @objc private func handleTextChange(textField: UITextField) {
    if textField == registrationView.fullNameTextfield {
      registrationViewModel.fullName = textField.text
    } else if textField == registrationView.emailTextfield {
      registrationViewModel.email = textField.text
    } else {
      registrationViewModel.password = textField.text
    }
  }
  
  @objc private func handleKeyboardShow(_ notification: Notification) {
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardHeight = value.cgRectValue.height
    let stackViewY = registrationView.stackView.frame.origin.y
    let stackViewHeight = registrationView.stackView.frame.height
    let bottomSpace = view.frame.height - stackViewY - stackViewHeight
    let difference = keyboardHeight - bottomSpace
    view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
  }
  
  @objc private func handleKeyboardHide(notification: Notification) {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 1,
      initialSpringVelocity: 1,
      options: .curveEaseOut,
      animations: {
        self.view.transform = .identity
    })
  }
  
  @objc private func handleTapGesture() {
    view.endEditing(true)
  }
  
  @objc private func handleGoToLoginTapped() {
    let loginController = LoginController()
    loginController.delegate = self.delegate
    navigationController?.show(loginController, sender: self)
  }
  
}

extension RegistrationController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[.originalImage] as? UIImage
    registrationView.selectPhotoButton.setImage(image, for: .normal)
    registrationViewModel.imageData = image?.jpegData(compressionQuality: 0.75) ?? Data()
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}
