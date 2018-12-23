//
//  HomeController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth
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
  
  var user: User?
  var lastFetchedUser: User?
  var cardViewModels: [CardViewModel] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    retrieveCurrentUser()
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
  
  fileprivate func retrieveCurrentUser() {
    progessHUD.show(in: view)
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
      self.progessHUD.dismiss()
      
      if let error = error {
        print(error)
        return
      }
      
      guard let dictionary = snapshot?.data() else { return }
      self.user = User(dictionary: dictionary)
      self.retrieveUsers()
    }
  }

  // MARK: - Helpers
  
  fileprivate func retrieveUsers() {
    guard let minSeekingAge = user?.minSeekingAge, let maxSeekingAge = user?.maxSeekingAge else { return }
    let query = Firestore.firestore().collection("users").whereField("age", isLessThan: maxSeekingAge)
                                                         .whereField("age", isGreaterThan: minSeekingAge)
    progessHUD.show(in: view)
    query.getDocuments { (snapshot, error) in
      if let error = error {
        self.progessHUD.dismiss()
        self.showHUDWithError(error)
        print(error)
        return
      }
      
      snapshot?.documents.forEach {
        let dictionary = $0.data()
        let user = User(dictionary: dictionary)
        self.cardViewModels.append(user.toCardViewModel())
        self.lastFetchedUser = user
        self.setupCardFromUser(user)
      }
      
      self.progessHUD.dismiss()
    }
  }
  
  fileprivate func setupCardFromUser(_ user: User) {
    let dummyCard = CardView()
    dummyCard.cardViewModel = user.toCardViewModel()
    self.cardDeckView.addSubview(dummyCard)
    self.cardDeckView.sendSubviewToBack(dummyCard)
    dummyCard.fillSuperview()
  }
  
  fileprivate func showHUDWithError(_ error: Error) {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Failed retrieving users"
    hud.detailTextLabel.text = error.localizedDescription
    hud.show(in: view)
    hud.dismiss(afterDelay: 2.5)
  }
  
  // MARK: - Selectors
  
  @objc fileprivate func handleProfileButtonTapped() {
    let profileController = ProfileController()
    profileController.delegate = self
    profileController.user = user
    let navController = UINavigationController(rootViewController: profileController)
    present(navController, animated: true, completion: nil)
  }

}

extension HomeController: ProfileDelegate {
  func profileWasSaved() {
    retrieveCurrentUser()
  }
}
