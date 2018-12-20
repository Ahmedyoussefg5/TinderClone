//
//  AppDelegate.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    FirebaseApp.configure()
    
    let registrationController = RegistrationController()
    let _ = HomeController()
    
    window = UIWindow()
    window?.rootViewController = registrationController
    window?.makeKeyAndVisible()
    
    return true
  }

}

