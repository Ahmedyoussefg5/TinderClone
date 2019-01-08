//
//  ProfileViewModel.swift
//  Tinder
//
//  Created by Jason Ngo on 2019-01-07.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

enum ProfileError: Error {
  case errorRetrievingCurrentUser(Error)
  case errorRetrievingCurrentUserUid
  case errorSavingCurrentUserInfo(Error)
  case errorSavingImage(Error)
  case errorRetrievingImageUrl(Error)
  case other
}

enum ImageUrls {
  case imageUrl1
  case imageUrl2
  case imageUrl3
}

class ProfileViewModel {
  
  var bindableIsRetrievingUser = Bindable<Bool>()
  var bindableIsSavingUserInfo = Bindable<Bool>()
  var bindableIsSavingImage = Bindable<Bool>()
  var bindableIsLoggingOut = Bindable<Bool>()
  
  var bindableImageUrl1 = Bindable<String>()
  var bindableImageUrl2 = Bindable<String>()
  var bindableImageUrl3 = Bindable<String>()
  
  func retrieveCurrentUser(completion: @escaping (User?, Error?) -> ()) {
    guard let uid = Auth.auth().currentUser?.uid else {
      completion(nil, ProfileError.errorRetrievingCurrentUserUid)
      return
    }
    
    bindableIsRetrievingUser.value = true
    
    Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
      self.bindableIsRetrievingUser.value = false
      
      if let error = error {
        completion(nil, ProfileError.errorRetrievingCurrentUser(error))
        return
      }
      
      guard let dictionary = snapshot?.data() else {
        completion(nil, ProfileError.other)
        return
      }
      
      let user = User(dictionary: dictionary)
      self.bindableImageUrl1.value = user.imageUrl1
      self.bindableImageUrl2.value = user.imageUrl2
      self.bindableImageUrl3.value = user.imageUrl3
      completion(user, nil)
    }
  }
  
  func saveUserInformation(data: [String: Any], completion: @escaping (Error?) -> ()) {
    guard let uid = Auth.auth().currentUser?.uid else {
      completion(ProfileError.errorRetrievingCurrentUserUid)
      return
    }
    
    bindableIsSavingUserInfo.value = true
    Firestore.firestore().collection("users").document(uid).setData(data) { (error) in
      self.bindableIsSavingUserInfo.value = false
      
      if let error = error {
        completion(ProfileError.errorSavingCurrentUserInfo(error))
        return
      }
      
      completion(nil)
    }
  }
  
  func saveImageToStorage(imageUrlType: ImageUrls, image: UIImage, completion: @escaping (String?, Error?) -> ()) {
    let filename = UUID().uuidString
    let data = image.jpegData(compressionQuality: 0.75) ?? Data()
    self.bindableIsSavingImage.value = true
    
    let ref = Storage.storage().reference(withPath: "/images/\(filename)")
    ref.putData(data, metadata: nil) { (_, error) in
      if let error = error {
        completion(nil, ProfileError.errorSavingImage(error))
        return
      }
      
      ref.downloadURL(completion: { (url, error) in
        if let error = error {
          completion(nil, ProfileError.errorRetrievingImageUrl(error))
          return
        }
        
        guard let url = url else { return }
        
        switch imageUrlType {
        case .imageUrl1:
          self.bindableImageUrl1.value = url.absoluteString
        case .imageUrl2:
          self.bindableImageUrl2.value = url.absoluteString
        case .imageUrl3:
          self.bindableImageUrl3.value = url.absoluteString
        }
        
        completion(url.absoluteString, nil)
      })
    }
  }
  
  func performLogOut(completion: @escaping (Error?) -> ()) {
    do {
      bindableIsLoggingOut.value = true
      try Auth.auth().signOut()
      bindableIsLoggingOut.value = false
      completion(nil)
    } catch let error {
      bindableIsLoggingOut.value = false
      completion(error)
    }
  }
  
}
