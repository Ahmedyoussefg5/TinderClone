//
//  CardViewModel.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

protocol CardViewModelProducer {
  func toCardViewModel() -> CardViewModel
}

class CardViewModel {

  let imageUrls: [String]
  let attributedText: NSAttributedString
  let textAlignment: NSTextAlignment
  
  init(imageUrls: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
    self.imageUrls = imageUrls
    self.attributedText = attributedText
    self.textAlignment = textAlignment
  }
  
}
