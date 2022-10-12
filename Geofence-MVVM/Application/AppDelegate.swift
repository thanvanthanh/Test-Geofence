//
//  AppDelegate.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 09/10/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: makeGeoFenceViewController())
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func makeGeoFenceViewController() -> UIViewController {
        let geoFenceVC = GeoFenceDependencyContainer()
        return geoFenceVC.makeViewController()
    }

}

