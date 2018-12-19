//
//  HomeViewController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  // MARK: - Views
  
  let topNavigationStackView = TopNavigationStackView()
  let cardDeckView = UIView()
  let bottomNavigationStackView = BottomNavigationStackView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    layoutSubviews()
  }
  
  // MARK: - Helper
  
  fileprivate func layoutSubviews() {
    let dummyCard = CardView()
    cardDeckView.addSubview(dummyCard)
    dummyCard.fillSuperview()
    
    let stackView = UIStackView(arrangedSubviews: [
      topNavigationStackView, cardDeckView, bottomNavigationStackView
    ])
    stackView.axis = .vertical
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
    stackView.bringSubviewToFront(cardDeckView)
    
    view.addSubview(stackView)
    stackView.anchor(
      top: view.safeAreaLayoutGuide.topAnchor,
      leading: view.leadingAnchor,
      bottom: view.safeAreaLayoutGuide.bottomAnchor,
      trailing: view.trailingAnchor
    )
  }

}

