//
//  HomeViewController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  let topNavigationStackView = TopNavigationStackView()
  let middleView = UIView()
  let bottomNavigationStackView = BottomNavigationStackView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    middleView.backgroundColor = .blue
    layoutSubviews()
  }
  
  // MARK: - Helper
  
  fileprivate func layoutSubviews() {
    let stackView = UIStackView(arrangedSubviews: [topNavigationStackView, middleView, bottomNavigationStackView])
    stackView.axis = .vertical
    view.addSubview(stackView)
    stackView.anchor(
      top: view.safeAreaLayoutGuide.topAnchor,
      leading: view.leadingAnchor,
      bottom: view.safeAreaLayoutGuide.bottomAnchor,
      trailing: view.trailingAnchor
    )
  }


}

