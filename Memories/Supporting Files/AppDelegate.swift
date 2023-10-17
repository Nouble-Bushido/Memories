//
//  AppDelegate.swift
//  Memories
//
//  Created by Артем Чжен on 04.09.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [HomePageViewController()]
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

