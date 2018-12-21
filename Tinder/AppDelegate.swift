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
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    
    let registrationController = RegistrationController()
    let homeController = HomeController()
    
    window = UIWindow()
    window?.rootViewController = homeController
    window?.makeKeyAndVisible()
    
    return true
  }

}

