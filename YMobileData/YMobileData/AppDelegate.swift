//
//  AppDelegate.swift
//  YMobileData
//
//  Created by ye on 2020/4/29.
//  Copyright © 2020 ye. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = ViewController()
        
        return true
    }



}

