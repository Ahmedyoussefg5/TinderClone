//
//  HomeController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HomeController: UIViewController {
  
  // MARK: - Views
  
  let topNavigationStackView = TopNavigationStackView()
  let cardDeckView = UIView()
  let bottomNavigationStackView = BottomNavigationStackView()
  
  // MARK: Model
  
//  var producers = [
//    User(uid: "1", fullName: "Kelly", age: 23, profession: "Teacher", imageNames: ["kelly1", "kelly2", "kelly3"]),
//    User(uid: "2", fullName: "Jane", age: 18, profession: "DJ", imageNames: ["jane1", "jane2", "jane3"]),
//    Advertiser(title: "Slide Out Twitter Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster"),
//    User(uid: "3", fullName: "Kelly", age: 23, profession: "Teacher", imageNames: ["kelly1", "kelly2", "kelly3"]),
//    User(uid: "4", fullName: "Jane", age: 18, profession: "DJ", imageNames: ["jane1", "jane2", "jane3"]),
//    Advertiser(title: "Slide Out Twitter Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster")
//  ] as [CardViewModelProducer]

  var producers: [CardViewModelProducer] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    retrieveUsers()
  }
  
  // MARK: - Setup
  
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
    
    topNavigationStackView.profileButton.addTarget(self, action: #selector(handleProfileButtonTapped), for: .touchUpInside)
  }
  
  fileprivate func retrieveUsers() {
    Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
      if let error = error {
        print(error)
        return
      }
      
      snapshot?.documents.forEach {
        let dictionary = $0.data()
        let user = User(dictionary: dictionary)
        self.producers.append(user)
      }
      
      let cardViewModels = self.producers.reversed().map { $0.toCardViewModel() }
      cardViewModels.forEach {
        let dummyCard = CardView()
        dummyCard.cardViewModel = $0
        self.cardDeckView.addSubview(dummyCard)
        self.cardDeckView.sendSubviewToBack(dummyCard)
        dummyCard.fillSuperview()
      }
    }
  }
  
  @objc fileprivate func handleProfileButtonTapped() {
    let profileController = ProfileController()
    let navController = UINavigationController(rootViewController: profileController)
    present(navController, animated: true, completion: nil)
  }

}

