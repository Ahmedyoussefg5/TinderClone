//
//  UserDetailsController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class UserDetailsController: UIViewController {
  
  lazy var scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.backgroundColor = .green
    sv.alwaysBounceVertical = true
    sv.contentInsetAdjustmentBehavior = .never
    sv.delegate = self
    return sv
  }()
  
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "kelly3").withRenderingMode(.alwaysOriginal)
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(scrollView)
    scrollView.fillSuperview()
    
    scrollView.addSubview(imageView)
    imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
  }
  
}

extension UserDetailsController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let changeY = -scrollView.contentOffset.y
    let width = max(view.frame.width, (view.frame.width + (changeY * 2)))
    let x = min(0, -changeY)
    imageView.frame = CGRect(x: x, y: x, width: width, height: width)
  }
}
