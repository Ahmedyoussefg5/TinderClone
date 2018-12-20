//
//  Advertiser.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

struct Advertiser {
  let title: String
  let brandName: String
  let posterPhotoName: String
}

extension Advertiser: CardViewModelProducer {
  
  func toCardViewModel() -> CardViewModel {
    let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .heavy)]
    let attributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)
    
    let brandNameAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .medium)]
    attributedText.append(NSAttributedString(string: "\n" + brandName, attributes: brandNameAttributes))
    
    return CardViewModel(imageName: posterPhotoName, attributedText: attributedText, textAlignment: .center)
  }
  
}

