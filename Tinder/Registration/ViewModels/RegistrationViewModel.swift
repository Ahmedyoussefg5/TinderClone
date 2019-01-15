//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import Foundation

final class RegistrationViewModel {
  
  var fullName: String? { didSet { checkFormIsValid() } }
  var email: String? { didSet { checkFormIsValid() } }
  var password: String? { didSet { checkFormIsValid() } }
  var imageData: Data?
  
  // MARK: - Bindable Properties
  
  var bindableIsFormValid = Bindable<Bool>()
  var bindableIsRegistering = Bindable<Bool>()
  
  fileprivate func checkFormIsValid() {
    let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
    bindableIsFormValid.value = isFormValid
  }
  
  // MARK: - Registration
  
  func performRegistration(completion: @escaping (Error?) -> ()) {
    guard let email = email else { return }
    guard let password = password else { return }
    bindableIsRegistering.value = true
    
    let values: [String: Any] = [
      "fullName": fullName ?? "",
      "age": 18,
      "minSeekingAge": 18,
      "maxSeekingAge": 50
    ]
    
    FirebaseAPI.shared.register(withEmail: email, password: password, values: values) { (error) in
      self.bindableIsRegistering.value = false
      
      if let error = error {
        completion(error)
        return
      }
      
      print("Successfully saved user profile information")
      completion(nil)
    }
  }
  
}

