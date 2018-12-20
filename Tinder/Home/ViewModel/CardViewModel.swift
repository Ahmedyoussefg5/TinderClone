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
  
  let imageNames: [String]
  let attributedText: NSAttributedString
  let textAlignment: NSTextAlignment
  
  init(imageNames: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
    self.imageNames = imageNames
    self.attributedText = attributedText
    self.textAlignment = textAlignment
  }
  
  // React to changes to selectedImageIndex
  var selectedImageObserver: ((Int, UIImage?) -> ())?
  
  private var selectedImageIndex = 0 {
    didSet {
      let imageName = imageNames[selectedImageIndex]
      let image = UIImage(named: imageName)
      selectedImageObserver?(selectedImageIndex, image)
    }
  }
  
}

// MARK: - Selected Image State

extension CardViewModel {
  
  func goToNextPhoto() {
    selectedImageIndex = min(selectedImageIndex + 1, imageNames.count - 1)
  }
  
  func goToPreviousPhoto() {
    selectedImageIndex = max(selectedImageIndex - 1, 0)
  }
  
}

