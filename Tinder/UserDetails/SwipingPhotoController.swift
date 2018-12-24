//
//  SwipingPhotoController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-24.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import SDWebImage

class SwipingPhotoController: UIPageViewController {
  
  var imageUrls: [String]? {
    didSet {
      guard let imageUrls = imageUrls else { return }
      controllers = imageUrls.map({ (imageUrl) -> UIViewController in
        let photoController = PhotoController(imageUrl: imageUrl)
        return photoController
      })
      
      setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
      setupBarViews()
    }
  }
  
  let barsStackView = UIStackView(arrangedSubviews: [])
  var controllers: [UIViewController] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    dataSource = self
    delegate = self
  }
  
  fileprivate func setupBarViews() {
    imageUrls?.forEach { _ in
      let barView = UIView()
      barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
      barView.layer.cornerRadius = 2
      barsStackView.addArrangedSubview(barView)
    }
    
    barsStackView.arrangedSubviews.first?.backgroundColor = .white
    barsStackView.spacing = 4
    barsStackView.distribution = .fillEqually
    
    view.addSubview(barsStackView)
    let paddingTop = UIApplication.shared.statusBarFrame.height + 8
    barsStackView.anchor(
      top: view.topAnchor,
      leading: view.leadingAnchor,
      bottom: nil,
      trailing: view.trailingAnchor,
      padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8),
      size: .init(width: 0, height: 4)
    )
  }
  
}

extension SwipingPhotoController: UIPageViewControllerDataSource & UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let index = controllers.firstIndex { $0 == viewController } ?? 0
    if index == 0 { return nil }
    return controllers[index - 1]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let index = controllers.firstIndex { $0 == viewController } ?? 0
    if index == controllers.count - 1 { return nil }
    return controllers[index + 1]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    let currentViewController = viewControllers?.first
    if let index = controllers.firstIndex(where: { $0 == currentViewController }) {
      barsStackView.arrangedSubviews.forEach { $0.backgroundColor = UIColor(white: 0, alpha: 0.1) }
      barsStackView.arrangedSubviews[index].backgroundColor = .white
    }
  }
  
}

class PhotoController: UIViewController {
  
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  init(imageUrl: String) {
    if let url = URL(string: imageUrl) {
      imageView.sd_setImage(with: url, completed: nil)
    }
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(imageView)
    imageView.fillSuperview()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
