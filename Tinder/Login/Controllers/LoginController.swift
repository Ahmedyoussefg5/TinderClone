//
//  LoginController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol RegisterAndLoginDelegate: class {
  func userLoggedIn()
}

final class LoginController: UIViewController {
  
  private var loginView = LoginView()
  private var loginViewModel = LoginViewModel()
  var delegate: RegisterAndLoginDelegate?
  
  private let loginHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Attempting to login"
    return hud
  }()
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupGestures()
    setupSubviewTargets()
    setupLoginViewModelBindables()
  }
  
  // MARK: - Setup
  
  private func setupLayout() {
    view.addSubview(loginView)
    loginView.fillSuperview()
    navigationController?.isNavigationBarHidden = true
  }
  
  private func setupGestures() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
  }
  
  private func setupSubviewTargets() {
    let fields = [loginView.emailTextField, loginView.passwordTextField]
    fields.forEach { $0.addTarget(self, action: #selector(handleTextChange), for: .editingChanged) }
    loginView.loginButton.addTarget(self, action: #selector(handleLoginTapped), for: .touchUpInside)
    loginView.goToRegistrationButton.addTarget(self, action: #selector(handleGoToRegistrationTapped), for: .touchUpInside)
  }
  
  private func setupLoginViewModelBindables() {
    loginViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
      guard let isFormValid = isFormValid else { return }
      self.loginView.loginButton.isEnabled = isFormValid
      
      if isFormValid {
        self.loginView.loginButton.backgroundColor = #colorLiteral(red: 0.8273344636, green: 0.09256268293, blue: 0.324395299, alpha: 1)
        self.loginView.loginButton.setTitleColor(.white, for: .normal)
      } else {
        self.loginView.loginButton.backgroundColor = .gray
        self.loginView.loginButton.setTitleColor(.darkGray, for: .normal)
      }
    }
    
    loginViewModel.bindableIsLoggingIn.bind { [unowned self] (isLoggingIn) in
      guard let isLoggingIn = isLoggingIn else { return }
      
      if isLoggingIn {
        self.loginHUD.show(in: self.view)
      } else {
        self.loginHUD.dismiss()
      }
    }
  }
  
  // MARK: - Selectors
  
  @objc private func handleTextChange(textField: UITextField) {
    if textField == loginView.emailTextField {
      loginViewModel.email = textField.text
    } else {
      loginViewModel.password = textField.text
    }
  }
  
  @objc private func handleLoginTapped() {
    view.endEditing(true)
    loginView.loginButton.isEnabled = false
    
    loginViewModel.performLogin { [unowned self] (error) in
      if let error = error {
        print(error)
        
        let hud = JGProgressHUD.errorHUD(with: "Failed Registration", error: error)
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.5)
        
        self.loginView.loginButton.isEnabled = true
        return
      }
      
      print("successfully logged in")
      self.dismiss(animated: true, completion: {
        self.delegate?.userLoggedIn()
      })
    }
  }
  
  @objc private func handleTapGesture() {
    view.endEditing(true)
  }
  
  @objc private func handleGoToRegistrationTapped() {
    navigationController?.popViewController(animated: true)
  }
  
}

