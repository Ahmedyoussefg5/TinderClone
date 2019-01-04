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
  
  var topCardView: CardView?
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
  var swipes: [String: Int] = [:]
  
  // MARK: - Overrides
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    if Auth.auth().currentUser == nil {
      let registrationController = RegistrationController()
      registrationController.delegate = self
      let navController = UINavigationController(rootViewController: registrationController)
      present(navController, animated: true, completion: nil)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupButtonTargets()
    retrieveCurrentUser()
  }
  
  // MARK: - Setup
  
  fileprivate func setupLayout() {
    view.backgroundColor = .white
    navigationController?.isNavigationBarHidden = true
    
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
  
  fileprivate func setupButtonTargets() {
    topNavigationStackView.profileButton.addTarget(self, action: #selector(handleProfileButtonTapped), for: .touchUpInside)
    bottomNavigationStackView.refreshButton.addTarget(self, action: #selector(handleRefreshTapped), for: .touchUpInside)
    bottomNavigationStackView.nopeButton.addTarget(self, action: #selector(handleNopeTapped), for: .touchUpInside)
    bottomNavigationStackView.superLikeButton.addTarget(self, action: #selector(handleSuperLikeTapped), for: .touchUpInside)
    bottomNavigationStackView.likeButton.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
    bottomNavigationStackView.boostButton.addTarget(self, action: #selector(handleBoostTapped), for: .touchUpInside)
  }
  
  fileprivate func retrieveCurrentUser() {
    cardDeckView.subviews.forEach { $0.removeFromSuperview() }
    guard let uid = Auth.auth().currentUser?.uid else { return }
    progessHUD.show(in: view)
    Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
      self.progessHUD.dismiss()
      
      if let error = error {
        print(error)
        return
      }
      
      guard let dictionary = snapshot?.data() else { return }
      self.user = User(dictionary: dictionary)
      self.retrieveUserSwipes()
    }
  }

  // MARK: - Helpers
  
  fileprivate func retrieveUserSwipes() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Firestore.firestore().collection("matches").document(uid).getDocument { (snapshot, error) in
      if let error = error {
        print("There was an error retrieving swipe information", error)
        return
      }
      
      if let data = snapshot?.data() as? [String: Int] {
        self.swipes = data
      }
      
      self.retrieveUsersFromFirestore()
    }
  }
  
  fileprivate func retrieveUsersFromFirestore() {
    guard let minSeekingAge = user?.minSeekingAge, let maxSeekingAge = user?.maxSeekingAge else { return }
    let query = Firestore.firestore().collection("users").whereField("age", isLessThanOrEqualTo: maxSeekingAge)
                                                         .whereField("age", isGreaterThanOrEqualTo: minSeekingAge)
    topCardView = nil
    progessHUD.show(in: view)
    query.getDocuments { (snapshot, error) in
      if let error = error {
        self.progessHUD.dismiss()
        self.showHUDWithError(error)
        print(error)
        return
      }
      
      var previousCardView: CardView?
      
      snapshot?.documents.forEach {
        let dictionary = $0.data()
        let user = User(dictionary: dictionary)
        
        let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
        let isNotSwipedByCurrentUser = self.swipes[user.uid!] == nil
        
        if isNotCurrentUser && isNotSwipedByCurrentUser {
          let cardView = self.setupCardFromUser(user)
          
          previousCardView?.nextCardView = cardView
          previousCardView = cardView
          
          if self.topCardView == nil {
            self.topCardView = cardView
          }
          
          self.cardViewModels.append(user.toCardViewModel())
          self.lastFetchedUser = user
        }
      }
      
      self.progessHUD.dismiss()
    }
  }
  
  fileprivate func setupCardFromUser(_ user: User) -> CardView {
    let userCard = CardView()
    userCard.delegate = self
    userCard.cardViewModel = user.toCardViewModel()
    self.cardDeckView.addSubview(userCard)
    self.cardDeckView.sendSubviewToBack(userCard)
    userCard.fillSuperview()
    return userCard
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
  
  @objc fileprivate func handleRefreshTapped() {
    cardDeckView.subviews.forEach { $0.removeFromSuperview() }
    retrieveUserSwipes()
  }
  
  @objc fileprivate func handleNopeTapped() {
    print("nope tapped")
    saveMatchInfo(didLike: 0)
    performSwipeAnimation(translation: -700, angle: -15)
  }
  
  @objc fileprivate func handleLikeTapped() {
    print("like tapped")
    saveMatchInfo(didLike: 1)
    performSwipeAnimation(translation: 700, angle: 15)
  }
  
  fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
    let duration = 0.5
    
    let translationAnimation = CABasicAnimation(keyPath: "position.x")
    translationAnimation.toValue = translation
    translationAnimation.duration = duration
    translationAnimation.fillMode = .forwards
    translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    translationAnimation.isRemovedOnCompletion = false
    
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = angle * CGFloat.pi / 180
    rotationAnimation.duration = duration
    
    let cardView = topCardView
    topCardView = cardView?.nextCardView
    
    CATransaction.setCompletionBlock {
      cardView?.removeFromSuperview()
    }
    
    cardView?.layer.add(translationAnimation, forKey: "translation")
    cardView?.layer.add(rotationAnimation, forKey: "rotation")
  }
  
  fileprivate func saveMatchInfo(didLike: Int) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    guard let matchUid = topCardView?.cardViewModel.uid else { return }
    
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Saving match information"
    hud.show(in: view)
    
    Firestore.firestore().collection("matches").document(uid).getDocument { (snapshot, error) in
      if let error = error {
        print("Error fetching match data", error)
        hud.dismiss()
        return
      }
    
      let data = [matchUid: didLike]
      if snapshot?.exists == true {
        Firestore.firestore().collection("matches").document(uid).updateData(data) { (error) in
          if let error = error {
            print("Error seting match data:", error)
            hud.dismiss()
            return
          }
          
          if didLike == 1 {
            self.checkForMatch(matchUid: matchUid)
          }
        }
      } else {
        Firestore.firestore().collection("matches").document(uid).setData(data) { (error) in
          if let error = error {
            print("Error seting match data:", error)
            hud.dismiss()
            return
          }
          
          if didLike == 1 {
            self.checkForMatch(matchUid: matchUid)
          }
        }
      }
      
      hud.dismiss()
    }
  }
  
  fileprivate func checkForMatch(matchUid: String) {
    Firestore.firestore().collection("matches").document(matchUid).getDocument { (snapshot, error) in
      if let error = error {
        print("Erroring fetching match information", error)
        return
      }
      
      guard let data = snapshot?.data() else { return }
      guard let currentUid = Auth.auth().currentUser?.uid else { return }
      
      let hasMatched = data[currentUid] as? Int == 1
      if hasMatched {
        print("Match found!")
        self.presentMatchView(matchUid: matchUid)
      }
    }
  }
  
  fileprivate func presentMatchView(matchUid: String) {
    let matchView = MatchView()
    matchView.cardUid = matchUid
    matchView.currentUser = user
    view.addSubview(matchView)
    matchView.fillSuperview()
  }
  
  @objc fileprivate func handleSuperLikeTapped() {
    let matchView = MatchView()
    view.addSubview(matchView)
    matchView.fillSuperview()
  }
  
  @objc fileprivate func handleBoostTapped() {}
  
}

extension HomeController: ProfileDelegate {
  func profileWasSaved() {
    retrieveCurrentUser()
  }
}

extension HomeController: RegisterAndLoginDelegate {
  func userLoggedIn() {
    retrieveCurrentUser()
  }
}

extension HomeController: CardViewDelegate {
  func didSwipeRight(cardView: CardView) {
    saveMatchInfo(didLike: 1)
    topCardView?.removeFromSuperview()
    topCardView = topCardView?.nextCardView
  }
  
  func didSwipeLeft(cardView: CardView) {
    saveMatchInfo(didLike: 0)
    topCardView?.removeFromSuperview()
    topCardView = topCardView?.nextCardView
  }
  
  func moreInformationTapped(cardViewModel: CardViewModel) {
    let userDetailsController = UserDetailsController()
    userDetailsController.cardViewModel = cardViewModel
    present(userDetailsController, animated: true, completion: nil)
  }
}
