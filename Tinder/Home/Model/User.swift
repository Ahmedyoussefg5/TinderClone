//
//  User.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

struct User {
  let name: String
  let age: Int
  let profession: String
  let imageName: String
}

extension User: CardViewModelProducer {
  
  func toCardViewModel() -> CardViewModel {
    let nameAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)]
    let attributedText = NSMutableAttributedString(string: name, attributes: nameAttributes)
    
    let ageAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
    attributedText.append(NSAttributedString(string: "  \(age)", attributes: ageAttributes))
    
    let professionAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
    attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: professionAttributes))
    
    return CardViewModel(imageName: imageName, attributedText: attributedText, textAlignment: .left)
  }
  
}


