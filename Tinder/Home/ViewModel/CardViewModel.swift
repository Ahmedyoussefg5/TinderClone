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
  
  var bindableSelectedImageIndex = Bindable<Int>()
  var bindableSelectedImage = Bindable<UIImage>()
  
  let imageNames: [String]
  let attributedText: NSAttributedString
  let textAlignment: NSTextAlignment
  
  init(imageNames: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
    self.imageNames = imageNames
    self.attributedText = attributedText
    self.textAlignment = textAlignment
    self.bindableSelectedImageIndex.value = 0
  }
  
}

// MARK: - Selected Image State

extension CardViewModel {
  
  func goToNextPhoto() {
    guard let oldValue = bindableSelectedImageIndex.value else { return }
    bindableSelectedImageIndex.value = min(oldValue + 1, imageNames.count - 1)
  }
  
  func goToPreviousPhoto() {
    guard let oldValue = bindableSelectedImageIndex.value else { return }
    bindableSelectedImageIndex.value = max(oldValue - 1, 0)
  }
  
}

