//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class RegistrationViewModel {
  
  var fullName: String? { didSet { checkFormIsValid() } }
  var email: String? { didSet { checkFormIsValid() } }
  var password: String? { didSet { checkFormIsValid() } }
  
  var isFormValidObserver: ((Bool) -> ())?
  
  fileprivate func checkFormIsValid() {
    let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
    isFormValidObserver?(isFormValid)
  }
  
}
