//
//  FirebaseAPI.swift
//  Tinder
//
//  Created by Jason Ngo on 2019-01-15.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

enum FirebaseError: Error {
  case unableToLogin(Error)
  case unableToCreateUser(Error)
  case unableToSaveUserProfileData(Error)
  case unableToRetrieveUserProfileDownloadUrl(Error)
  case unableToSaveUserInformation(Error)
  case other
}

final class FirebaseAPI {
  
  static let shared = FirebaseAPI()
  private init() {}
  
  // MARK: - Authentication

  func login(withEmail: String, password: String, completion: @escaping (FirebaseError?)->()) {
    Auth.auth().signIn(withEmail: withEmail, password: password) { (_, error) in
      if let error = error {
        completion(FirebaseError.unableToLogin(error))
        return
      }
      
      completion(nil)
    }
  }
  
  // MARK: - Registration
  
  func register(withEmail: String, password: String, values: [String: Any], completion: @escaping (FirebaseError?) -> ()) {
    Auth.auth().createUser(withEmail: withEmail, password: password) { (response, error) in
      if let error = error {
        completion(FirebaseError.unableToCreateUser(error))
        return
      }
      
      guard let uid = response?.user.uid else {
        completion(FirebaseError.other)
        return
      }
      
      print("successfully registered user. user uid:", uid)
      self.saveImageToFirebase(uid: uid, values: values, completion: completion)
    }
  }
  
  private func saveImageToFirebase(uid: String, values: [String: Any], completion: @escaping (FirebaseError?)->()) {
    let filename = UUID().uuidString
    let ref = Storage.storage().reference(withPath: "/images/\(filename)")
    let imageData = values["imageData"] as? Data ?? Data()
    
    ref.putData(imageData, metadata: nil, completion: { (_, error) in
      if let error = error {
        completion(FirebaseError.unableToSaveUserProfileData(error))
        return
      }
      
      print("Successfully uploaded image to firebase storage")
      ref.downloadURL(completion: { (url, error) in
        if let error = error {
          completion(FirebaseError.unableToRetrieveUserProfileDownloadUrl(error))
          return
        }
        
        guard let imageUrl = url?.absoluteString else {
          completion(FirebaseError.other)
          return
        }
        
        print("Successfully downloaded image url:", imageUrl)
        self.saveInfoToFirestore(uid: uid, imageUrl: imageUrl, values: values, completion: completion)
      })
    })
  }
  
  private func saveInfoToFirestore(uid: String, imageUrl: String, values: [String: Any], completion: @escaping (FirebaseError?)->()) {
    var documentData = values
    documentData["uid"] = uid
    documentData["imageUrl1"] = imageUrl
    
    Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
      if let error = error {
        completion(FirebaseError.unableToSaveUserInformation(error))
        return
      }
      
      completion(nil)
    }
  }
  
}
