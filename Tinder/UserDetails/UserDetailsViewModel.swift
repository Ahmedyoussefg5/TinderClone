//
//  UserDetailsViewModel.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-24.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

protocol UserDetailsViewModelProducer {
  func toUserDetailsViewModel() -> UserDetailsViewModel
}

class UserDetailsViewModel {
  
  var imageUrls: [String]?
  var attributedString: NSAttributedString?
  
  init(imageUrls: [String]?, attributedString: NSAttributedString?) {
    self.imageUrls = imageUrls
    self.attributedString = attributedString
  }
  
}

extension UserDetailsViewModel {
  
}


extension UserDetailsViewModel {
  func retrieveUserImage(completion: @escaping ()->()) {
    completion()
  }
}
