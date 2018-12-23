//
//  ProfileController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-21.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import JGProgressHUD
import SDWebImage

class ProfileController: UITableViewController {
  
  // MARK: - Views
  
  let progessHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Fetching user info"
    return hud
  }()
  
  let updatingProfileHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Updating profile"
    return hud
  }()

  let image1Button = ProfileImageButton(type: .system)
  let image2Button = ProfileImageButton(type: .system)
  let image3Button = ProfileImageButton(type: .system)
  
  lazy var header: UIView = {
    let header = UIView()
    
    header.addSubview(image1Button)
    image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
    image1Button.anchor(
    top: header.topAnchor,
    leading: header.leadingAnchor,
    bottom: header.bottomAnchor,
    trailing: nil,
    padding: .init(top: 16, left: 16, bottom: 16, right: 0)
    )
    
    let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.distribution = .fillEqually
    
    header.addSubview(stackView)
    stackView.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
    stackView.anchor(
      top: header.topAnchor,
      leading: nil,
      bottom: header.bottomAnchor,
      trailing: header.trailingAnchor,
      padding: .init(top: 16, left: 0, bottom: 16, right: 16)
    )
    
    return header
  }()
  
  let sectionTitles = ["Header", "Name", "Profession", "Age", "Bio"]
  
  var user: User?
  
  // MARK: - Configuation constants
  
  fileprivate let profileBackgroundColor = UIColor(white: 0.95, alpha: 1)
  fileprivate let profileTitleText = "Settings"
  
  // MARK: - Inner classes
  
  class ProfileImagePicker: UIImagePickerController {
    var selectedButton: UIButton?
  }
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    retrieveCurrentUser()
  }
  
  // MARK: - Setup
  
  fileprivate func setupLayout() {
    title = profileTitleText
    navigationController?.navigationBar.prefersLargeTitles = true
    
    tableView.backgroundColor = profileBackgroundColor
    tableView.keyboardDismissMode = .interactive
    tableView.tableFooterView = UIView()
    
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelTapped))
    let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancelTapped))
    let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveTapped))
    
    navigationItem.leftBarButtonItem = cancelButton
    navigationItem.rightBarButtonItems = [logoutButton, saveButton]
    
    [image1Button, image2Button, image3Button].forEach {
      $0.addTarget(self, action: #selector(handleImageButtonTapped), for: .touchUpInside)
    }
  }
  
  fileprivate func retrieveCurrentUser() {
    progessHUD.show(in: view)
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let dictionary = snapshot?.data() else { return }
      self.user = User(dictionary: dictionary)
      self.loadUserPhotos()
      self.tableView.reloadData()
    }
  }
  
  @objc fileprivate func handleCancelTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc fileprivate func handleSaveTapped() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    guard let documentData = user?.toDictionary() else { return }
    view.endEditing(true)
    updatingProfileHUD.show(in: view)
    Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
      self.updatingProfileHUD.dismiss()
      
      if let error = error {
        print(error)
        return
      }
      
      print("successfully updated user settings")
    }
  }
  
  @objc fileprivate func handleImageButtonTapped(button: UIButton) {
    let profileImagePicker = ProfileImagePicker()
    profileImagePicker.selectedButton = button
    profileImagePicker.delegate = self
    present(profileImagePicker, animated: true, completion: nil)
  }
  
  fileprivate func loadUserPhotos() {
    if let imageUrl1 = user?.imageUrl1, let url = URL(string: imageUrl1) {
      SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
        self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      }
    }
    if let imageUrl2 = user?.imageUrl2, let url = URL(string: imageUrl2) {
      SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
        self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      }
    }
    if let imageUrl3 = user?.imageUrl3, let url = URL(string: imageUrl3) {
      SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
        self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      }
    }
    self.progessHUD.dismiss()
  }
  
}

// MARK: - TableView

extension ProfileController {
  
  // MARK: Header
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      return header
    }
    
    let label = ProfileSectionLabel()
    label.text = sectionTitles[section]
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? 300 : 40
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 0 : 1
  }
  
  @objc fileprivate func handleEditingChanged(textField: UITextField) {
    switch textField.tag {
    case 1:
      user?.fullName = textField.text
    case 2:
      user?.profession = textField.text
    case 3:
      guard let age = textField.text else { return }
      user?.age = Int(age)
    case 4:
      user?.bio = textField.text
    default:
      ()
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ProfileCell.init(style: .default, reuseIdentifier: nil)
    
    switch indexPath.section {
    case 1:
      cell.textField.placeholder = "Enter full name"
      cell.textField.text = user?.fullName
      cell.textField.tag = 1
      cell.textField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    case 2:
      cell.textField.placeholder = "Enter profession"
      cell.textField.text = user?.profession
      cell.textField.tag = 2
      cell.textField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    case 3:
      cell.textField.keyboardType = .numberPad
      cell.textField.tag = 3
      cell.textField.placeholder = "Enter age"
      cell.textField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
      if let age = user?.age {
        cell.textField.text = String(age)
      }
    case 4:
      cell.textField.placeholder = "Enter bio"
      cell.textField.text = user?.bio
      cell.textField.tag = 4
      cell.textField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    default:
      ()
    }
    
    return cell
  }
  
}

extension ProfileController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = (info[.originalImage] as? UIImage)?.withRenderingMode(.alwaysOriginal) else { return }
    (picker as? ProfileImagePicker)?.selectedButton?.setImage(image, for: .normal)
    saveImageToFirebaseStorage(image) { [weak self] (downloadUrl) in
      guard let self = self else { return }
      guard let button = (picker as? ProfileImagePicker)?.selectedButton else { return }
      if button == self.image1Button {
        self.user?.imageUrl1 = downloadUrl
      } else if button == self.image2Button {
        self.user?.imageUrl2 = downloadUrl
      } else {
        self.user?.imageUrl3 = downloadUrl
      }
    }
    dismiss(animated: true, completion: nil)
  }
  
  fileprivate func saveImageToFirebaseStorage(_ image: UIImage, completion: @escaping (String?)->()) {
    let filename = UUID().uuidString
    let data = image.jpegData(compressionQuality: 0.75) ?? Data()
    let ref = Storage.storage().reference(withPath: "/images/\(filename)")
    ref.putData(data, metadata: nil, completion: { (_, error) in
      if let error = error {
        print(error)
        return
      }
      
      print("Successfully uploaded image to firebase storage")
      ref.downloadURL(completion: { (url, error) in
        if let error = error {
          print(error)
          return
        }
        
        print("Successfully downloaded image url:", url?.absoluteString ?? "")
        completion(url?.absoluteString)
      })
    })
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}

