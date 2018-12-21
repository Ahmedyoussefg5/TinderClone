//
//  ProfileController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-21.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController {
  
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
  
  let sectionDescriptions = [
    ("Header", "None"),
    ("Name", "Enter name"),
    ("Profession", "Enter profession"),
    ("Age", "Enter age"),
    ("Bio", "Enter bio")
  ]
  
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
  }
  
  // MARK: - Setup
  
  fileprivate func setupLayout() {
    title = profileTitleText
    tableView.backgroundColor = profileBackgroundColor
    tableView.keyboardDismissMode = .interactive
    tableView.tableFooterView = UIView()
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelTapped))
    let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancelTapped))
    let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancelTapped))
    
    navigationItem.leftBarButtonItem = cancelButton
    navigationItem.rightBarButtonItems = [logoutButton, saveButton]
    
    [image1Button, image2Button, image3Button].forEach {
      $0.addTarget(self, action: #selector(handleImageButtonTapped), for: .touchUpInside)
    }
    
  }
  
  @objc fileprivate func handleCancelTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc fileprivate func handleImageButtonTapped(button: UIButton) {
    let profileImagePicker = ProfileImagePicker()
    profileImagePicker.selectedButton = button
    profileImagePicker.delegate = self
    present(profileImagePicker, animated: true, completion: nil)
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
    label.text = sectionDescriptions[section].0
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
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ProfileCell.init(style: .default, reuseIdentifier: nil)
    cell.textField.placeholder = sectionDescriptions[indexPath.section].1
    if indexPath.section == 3 {
      cell.textField.keyboardType = .numberPad
    }
    return cell
  }
  
}

extension ProfileController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = (info[.originalImage] as? UIImage)?.withRenderingMode(.alwaysOriginal)
    (picker as? ProfileImagePicker)?.selectedButton?.setImage(image, for: .normal)
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}

