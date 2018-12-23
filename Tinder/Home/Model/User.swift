//
//  User.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

struct User: Codable {
  var uid: String?
  var fullName: String?
  var age: Int?
  var profession: String?
  var imageUrl1: String?
  var imageUrl2: String?
  var imageUrl3: String?
  var bio: String?
}

extension User {
  init(dictionary: [String: Any]) {
    self.uid = dictionary["uid"] as? String
    self.fullName = dictionary["fullName"] as? String
    self.age = dictionary["age"] as? Int
    self.profession = dictionary["profession"] as? String
    self.imageUrl1 = dictionary["imageUrl1"] as? String
    self.imageUrl2 = dictionary["imageUrl2"] as? String
    self.imageUrl3 = dictionary["imageUrl3"] as? String
    self.bio = dictionary["bio"] as? String
  }
  
  func toDictionary() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary["uid"] = uid
    dictionary["fullName"] = fullName
    dictionary["age"] = age
    dictionary["profession"] = profession
    dictionary["imageUrl1"] = imageUrl1
    dictionary["imageUrl2"] = imageUrl2
    dictionary["imageUrl3"] = imageUrl3
    dictionary["bio"] = bio
    return dictionary
  }
}

extension User: CardViewModelProducer {
  
  func toCardViewModel() -> CardViewModel {
    let nameText = fullName ?? "Name Not Available"
    let nameAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)]
    let attributedText = NSMutableAttributedString(string: nameText, attributes: nameAttributes)
    
    let ageText = age != nil ? "  \(age!)" : "  N\\A"
    let ageAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
    attributedText.append(NSAttributedString(string: ageText, attributes: ageAttributes))
    
    let professionText = profession != nil ? "\n\(profession!)" : "\nNot available"
    let professionAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
    attributedText.append(NSAttributedString(string: professionText, attributes: professionAttributes))
    
    let imageNames = [imageUrl1 ?? "", imageUrl2 ?? "", imageUrl3 ?? ""]
    return CardViewModel(imageUrls: imageNames, attributedText: attributedText, textAlignment: .left)
  }
  
}


