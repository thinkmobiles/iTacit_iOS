//
//  AppDelegate.swift
//  iTacit
//
//  Created by Sauron Black on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		setupNavigationBarApperance()
		return true
	}

	private func setupNavigationBarApperance() {
		UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
		UINavigationBar.appearance().translucent = false
		UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.openSansRegular(17.0), NSForegroundColorAttributeName: AppColors.darkGray]
		UINavigationBar.appearance().backIndicatorImage = UIImage(assetsIndetifier: .BackButton)
		UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(assetsIndetifier: .BackButton)
		UINavigationBar.appearance().tintColor = AppColors.darkGray
	}
}
