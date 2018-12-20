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

struct CardViewModel {
  let imageName: String
  let attributedText: NSAttributedString
  let textAlignment: NSTextAlignment
}


