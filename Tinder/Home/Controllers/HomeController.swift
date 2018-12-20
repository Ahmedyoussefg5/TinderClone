//
//  HomeController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
  
  // MARK: - Views
  
  let topNavigationStackView = TopNavigationStackView()
  let cardDeckView = UIView()
  let bottomNavigationStackView = BottomNavigationStackView()
  
  // MARK: Model
  
  var producers = [
    User(name: "Kelly", age: 23, profession: "Teacher", imageNames: ["kelly1", "kelly2", "kelly3"]),
    User(name: "Jane", age: 18, profession: "DJ", imageNames: ["jane1", "jane2", "jane3"]),
    Advertiser(title: "Slide Out Twitter Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster"),
    User(name: "Kelly", age: 23, profession: "Teacher", imageNames: ["kelly1", "kelly2", "kelly3"]),
    User(name: "Jane", age: 18, profession: "DJ", imageNames: ["jane1", "jane2", "jane3"]),
    Advertiser(title: "Slide Out Twitter Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster")
  ] as [CardViewModelProducer]

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    
    let cardViewModels = producers.reversed().map { $0.toCardViewModel() }
    cardViewModels.forEach {
      let dummyCard = CardView()
      dummyCard.cardViewModel = $0
      cardDeckView.addSubview(dummyCard)
      dummyCard.fillSuperview()
    }
  }
  
  // MARK: - Helper
  
  fileprivate func setupLayout() {
    view.backgroundColor = .white
    
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

