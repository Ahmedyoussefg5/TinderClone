//
//  LoginViewModel.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import Foundation

final class LoginViewModel {
  
  var email: String? { didSet { checkFormIsValid() }}
  var password: String? { didSet { checkFormIsValid() }}
  
  var bindableIsFormValid = Bindable<Bool>()
  var bindableIsLoggingIn = Bindable<Bool>()
  
  private func checkFormIsValid() {
    let isFormValid = email?.isEmpty == false && password?.isEmpty == false
    bindableIsFormValid.value = isFormValid
  }
  
  func performLogin(completion: @escaping (Error?) -> ()) {
    guard let email = email else { return }
    guard let password = password else { return }
    bindableIsLoggingIn.value = true
    
    FirebaseAPI.shared.login(withEmail: email, password: password) { (error) in
      if let error = error {
        completion(error)
        return
      }
      
      completion(nil)
    }
  }
  
}

