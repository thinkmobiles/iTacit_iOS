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
		setupApperance()
		return true
	}

	private func setupApperance() {
		UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
		UINavigationBar.appearance().translucent = false
		UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.openSansRegular(17.0), NSForegroundColorAttributeName: AppColors.darkGray]
		UINavigationBar.appearance().setTitleVerticalPositionAdjustment(-3.5, forBarMetrics: .Default)
		UINavigationBar.appearance().tintColor = AppColors.darkGray
		let barItemTextAttributes = [NSFontAttributeName: UIFont.openSansRegular(14.0), NSForegroundColorAttributeName: AppColors.gray]
		UIBarButtonItem.appearance().setTitleTextAttributes(barItemTextAttributes, forState: .Normal)
		UITextView.appearance().tintColor = AppColors.darkGray
	}
}
