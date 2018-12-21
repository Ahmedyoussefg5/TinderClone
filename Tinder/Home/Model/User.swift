//
//  User.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

struct User {
  var uid: String?
  var fullName: String?
  var age: Int?
  var profession: String?
  var imageNames: [String]?
}

extension User {
  init(dictionary: [String: Any]) {
    self.uid = dictionary["uid"] as? String
    self.fullName = dictionary["fullName"] as? String
    self.age = dictionary["age"] as? Int
    self.profession = dictionary["profession"] as? String
    self.imageNames = [dictionary["imageUrl1"] as? String ?? ""]
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
    
    return CardViewModel(imageNames: imageNames ?? [], attributedText: attributedText, textAlignment: .left)
  }
  
}


