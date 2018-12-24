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
    }
  }
  
  var controllers: [UIViewController] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    dataSource = self
  }
  
}

extension SwipingPhotoController: UIPageViewControllerDataSource {
  
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
