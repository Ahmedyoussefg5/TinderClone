//
//  Bindable.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import Foundation

class Bindable<T> {
  var value: T? {
    didSet {
      observer?(value)
    }
  }
  
  var observer: ((T?)->())?
  
  func bind(observer: @escaping (T?) -> ()) {
    self.observer = observer
  }
}
