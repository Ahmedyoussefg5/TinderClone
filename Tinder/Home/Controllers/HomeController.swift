//
//  HomeController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseFirestore
import JGProgressHUD

class HomeController: UIViewController {
  
  // MARK: - Views
  
  let topNavigationStackView = TopNavigationStackView()
  let cardDeckView = UIView()
  let bottomNavigationStackView = BottomNavigationStackView()
  
  let progessHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Fetching users"
    return hud
  }()
  
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
    progessHUD.show(in: view)
    Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
      if let error = error {
        self.progessHUD.dismiss()
        self.showHUDWithError(error)
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
      
      self.progessHUD.dismiss()
    }
  }
  
  @objc fileprivate func handleProfileButtonTapped() {
    let profileController = ProfileController()
    let navController = UINavigationController(rootViewController: profileController)
    present(navController, animated: true, completion: nil)
  }
  
  fileprivate func showHUDWithError(_ error: Error) {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Failed retrieving users"
    hud.detailTextLabel.text = error.localizedDescription
    hud.show(in: view)
    hud.dismiss(afterDelay: 2.5)
  }

}

