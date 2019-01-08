//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class RegistrationViewModel {
  
  // MARK: - Bindable Properties
  
  var bindableImage = Bindable<UIImage>()
  var bindableIsFormValid = Bindable<Bool>()
  var bindableIsRegistering = Bindable<Bool>()
  
  var fullName: String? { didSet { checkFormIsValid() } }
  var email: String? { didSet { checkFormIsValid() } }
  var password: String? { didSet { checkFormIsValid() } }
  
  fileprivate func checkFormIsValid() {
    let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
    bindableIsFormValid.value = isFormValid
  }
  
  // MARK: - Registration
  
  func performRegistration(completion: @escaping (Error?) -> ()) {
    guard let email = email else { return }
    guard let password = password else { return }
    bindableIsRegistering.value = true
    
    Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
      self.bindableIsRegistering.value = false
      
      if let error = error {
        completion(error)
        return
      }
      
      print("Successfully registered user:", response?.user.uid ?? "")
      self.saveImageToFirebase(completion: completion)
    }
  }
  
  fileprivate func saveImageToFirebase(completion: @escaping (Error?)->()) {
    let filename = UUID().uuidString
    let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
    let ref = Storage.storage().reference(withPath: "/images/\(filename)")
    ref.putData(imageData, metadata: nil, completion: { (_, error) in
      if let error = error {
        completion(error)
        return
      }
      
      print("Successfully uploaded image to firebase storage")
      ref.downloadURL(completion: { (url, error) in
        if let error = error {
          completion(error)
          return
        }
        
        print("Successfully downloaded image url:", url?.absoluteString ?? "")
        self.saveInfoToFirestore(imageUrl: url?.absoluteString ?? "", completion: completion)
      })
    })
  }
  
  fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?)->()) {
    let uid = Auth.auth().currentUser?.uid ?? ""
    let documentData: [String: Any] = [
      "fullName": fullName ?? "",
      "uid": uid,
      "age": 18,
      "imageUrl1": imageUrl,
      "minSeekingAge": 18,
      "maxSeekingAge": 50
    ]
    
    Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
      if let error = error {
        completion(error)
        return
      }
      
      print("Successfully saved user info")
      self.bindableIsRegistering.value = false
      completion(nil)
    }
  }
  
}

