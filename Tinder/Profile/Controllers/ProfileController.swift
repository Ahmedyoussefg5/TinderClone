//
//  ProfileController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-21.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import JGProgressHUD
import SDWebImage

protocol ProfileDelegate {
  func profileWasSaved()
}

class ProfileController: UITableViewController {
  var user: User?
  var delegate: ProfileDelegate?
  var profileViewModel = ProfileViewModel()
  
  // MARK: - Configuation constants
  
  fileprivate let sectionTitles = ["Header", "Name", "Profession", "Age", "Bio", "Seeking Age Range"]
  fileprivate let profileBackgroundColor = UIColor(white: 0.95, alpha: 1)
  fileprivate let profileTitleText = "Settings"
  
  // MARK: - Views

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
  
  let retrievingUserHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Retrieving user info"
    return hud
  }()
  
  let updatingProfileHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Updating profile"
    return hud
  }()
  
  let downloadingImageHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Downloading Image"
    return hud
  }()
  
  // MARK: - Inner classes
  
  class ProfileImagePicker: UIImagePickerController {
    var selectedButtonType: ImageUrls!
    var selectedButton: UIButton?
  }
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupViewModelObservers()
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
    let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogoutTapped))
    let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveTapped))
    
    navigationItem.leftBarButtonItem = cancelButton
    navigationItem.rightBarButtonItems = [logoutButton, saveButton]
    
    [image1Button, image2Button, image3Button].forEach {
      $0.addTarget(self, action: #selector(handleImageButtonTapped), for: .touchUpInside)
    }
  }
  
  fileprivate func setupViewModelObservers() {
    profileViewModel.bindableIsRetrievingUser.bind { [unowned self] (isRetrievingUser) in
      guard let isRetrievingUser = isRetrievingUser else { return }
      if isRetrievingUser {
        self.retrievingUserHUD.show(in: self.view)
      } else {
        self.retrievingUserHUD.dismiss()
      }
    }
    
    profileViewModel.bindableIsSavingUserInfo.bind { [unowned self] (isSavingUser) in
      guard let isSavingUser = isSavingUser else { return }
      if isSavingUser {
        self.updatingProfileHUD.show(in: self.view)
      } else {
        self.updatingProfileHUD.dismiss()
      }
    }
    
    profileViewModel.bindableIsSavingImage.bind { [unowned self] (isSavingImage) in
      guard let isSavingImage = isSavingImage else { return }
      if isSavingImage {
        self.downloadingImageHUD.show(in: self.view)
      } else {
        self.downloadingImageHUD.dismiss()
      }
    }
    
    profileViewModel.bindableImageUrl1.bind { [unowned self] (urlString) in
      guard let urlString = urlString else { return }
      guard let url = URL(string: urlString) else { return }
      self.profileViewModel.bindableIsSavingImage.value = true
      SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil, completed: {
        (image, _, _, _, _, _) in
        self.profileViewModel.bindableIsSavingImage.value = false
        self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      })
    }
    
    profileViewModel.bindableImageUrl2.bind { [unowned self] (urlString) in
      guard let urlString = urlString else { return }
      guard let url = URL(string: urlString) else { return }
      self.profileViewModel.bindableIsSavingImage.value = true
      SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil, completed: {
        (image, _, _, _, _, _) in
        self.profileViewModel.bindableIsSavingImage.value = false
        self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      })
    }
    
    profileViewModel.bindableImageUrl3.bind { [unowned self] (urlString) in
      guard let urlString = urlString else { return }
      guard let url = URL(string: urlString) else { return }
      SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil, completed: {
        (image, _, _, _, _, _) in
        self.profileViewModel.bindableIsSavingImage.value = false
        self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      })
    }
  }
  
  // MARK: - Helpers
  
  fileprivate func retrieveCurrentUser() {
    guard user == nil else {
      profileViewModel.bindableImageUrl1.value = user?.imageUrl1
      profileViewModel.bindableImageUrl2.value = user?.imageUrl2
      profileViewModel.bindableImageUrl3.value = user?.imageUrl3
      tableView.reloadData()
      return
    }
    
    profileViewModel.retrieveCurrentUser { (user, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let user = user else { return }
      self.user = user
      self.tableView.reloadData()
    }
  }
  
  // MARK: - Selectors
  
  // MARK: Top navigation buttons
  
  @objc fileprivate func handleCancelTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc fileprivate func handleLogoutTapped() {
    profileViewModel.performLogOut { [unowned self] (error) in
      if let error = error {
        // TODO: Show error HUD
        print(error)
        return
      }
      
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc fileprivate func handleSaveTapped() {
    guard let documentData = user?.toDictionary() else { return }
    view.endEditing(true)
    
    profileViewModel.saveUserInformation(data: documentData) { [unowned self] (error) in
      if let error = error {
        // TODO: Show error HUD
        print(error)
        return
      }
      
      self.dismiss(animated: true, completion: {
        self.delegate?.profileWasSaved()
      })
    }
  }
  
  // MARK: - ImageButtons
  
  @objc fileprivate func handleImageButtonTapped(button: UIButton) {
    let profileImagePicker = ProfileImagePicker()
    
    if button == image1Button {
      profileImagePicker.selectedButtonType = .imageUrl1
    } else if button == image2Button {
      profileImagePicker.selectedButtonType = .imageUrl2
    } else {
      profileImagePicker.selectedButtonType = .imageUrl3
    }
    
    profileImagePicker.selectedButton = button
    profileImagePicker.delegate = self
    present(profileImagePicker, animated: true, completion: nil)
  }
  
  // MARK: Sliders
  
  @objc fileprivate func handleMinAgeChanged(slider: UISlider) {
    guard let ageRangeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? AgeRangeCell else { return }
    
    let value = Int(slider.value)
    if value <= Int(ageRangeCell.maxAgeSlider.value) {
      ageRangeCell.minAgeLabel.text = "Min: \(value)"
      user?.minSeekingAge = value
    } else {
      ageRangeCell.minAgeSlider.value = ageRangeCell.maxAgeSlider.value
    }
  }
  
  @objc fileprivate func handleMaxAgeChanged(slider: UISlider) {
    guard let ageRangeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? AgeRangeCell else { return }
    
    let value = Int(slider.value)
    if value <= Int(ageRangeCell.minAgeSlider.value) {
      ageRangeCell.minAgeSlider.value = ageRangeCell.maxAgeSlider.value
      handleMinAgeChanged(slider: ageRangeCell.minAgeSlider)
    }

    ageRangeCell.maxAgeLabel.text = "Max: \(value)"
    user?.maxSeekingAge = value
  }
  
  // MARK: - Helpers
  
  fileprivate func showHUDWithError(_ error: Error) {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Failed Registration"
    hud.detailTextLabel.text = error.localizedDescription
    hud.show(in: view)
    hud.dismiss(afterDelay: 2.5)
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
    return 6
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
    case 5:
      let ageRangeCell = AgeRangeCell.init(style: .default, reuseIdentifier: nil)
      ageRangeCell.minAgeSlider.value = Float(user?.minSeekingAge ?? 18)
      ageRangeCell.minAgeLabel.text = "Min: \(user?.minSeekingAge ?? 18)"
      ageRangeCell.minAgeSlider.addTarget(self, action: #selector(handleMinAgeChanged), for: .valueChanged)
      ageRangeCell.maxAgeSlider.value = Float(user?.maxSeekingAge ?? 18)
      ageRangeCell.maxAgeLabel.text = "Max: \(user?.maxSeekingAge ?? 18)"
      ageRangeCell.maxAgeSlider.addTarget(self, action: #selector(handleMaxAgeChanged), for: .valueChanged)
      return ageRangeCell
    default:
      ()
    }
    
    return cell
  }
  
}

extension ProfileController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = (info[.originalImage] as? UIImage)?.withRenderingMode(.alwaysOriginal) else { return }
    guard let picker = picker as? ProfileImagePicker else { return }
    
    picker.selectedButton?.setImage(image, for: .normal)
    let imageUrlType = picker.selectedButtonType!
    
    profileViewModel.saveImageToStorage(imageUrlType: imageUrlType, image: image) { (downloadUrl, error) in
      if let error = error {
        self.showHUDWithError(error)
        return
      }
      
      guard let downloadUrl = downloadUrl else { return }

      switch imageUrlType {
      case .imageUrl1:
        self.user?.imageUrl1 = downloadUrl
      case .imageUrl2:
        self.user?.imageUrl2 = downloadUrl
      case .imageUrl3:
        self.user?.imageUrl3 = downloadUrl
      }
    }

    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}

