//
//  TabBarController.swift
//  TabBarController
//
//  Created by Sauron Black on 10/14/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import UIKit

class TabBarController: UIViewController {

	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var mainTabBarButton: TabBarButton!

	var viewControllers = [UIViewController]()
	var currentViewController: UIViewController?

	private var selectedTabBarButton: TabBarButton?

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBarHidden = true
		performSegueWithIdentifier("TabSegue1", sender: self)
		performSegueWithIdentifier("TabSegue2", sender: self)
		performSegueWithIdentifier("TabSegue3", sender: self)
		performSegueWithIdentifier("TabSegue4", sender: self)
		switchTab(mainTabBarButton)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	// MARK: - Private

	private func removeViewController(viewController: UIViewController) {
		viewController.willMoveToParentViewController(nil)
		viewController.removeFromParentViewController()
		viewController.view.removeFromSuperview()
	}

	private func showChildViewController(child: UIViewController) {
		if let currentViewController = currentViewController {
			removeViewController(currentViewController)
		}
		UIControlEvents
		currentViewController = child
		addChildViewController(child)
		child.didMoveToParentViewController(self)
		containerView.addSubview(child.view)
		child.view.frame = containerView.bounds
	}

	// MARK: - IBActions

	@IBAction func switchTab(sender: TabBarButton) {
		if let selectedTabBarButton = selectedTabBarButton where selectedTabBarButton == sender {
			return
		}

		selectedTabBarButton?.selected = false
		sender.selected = true

		if sender.tag < viewControllers.count {
			showChildViewController(viewControllers[sender.tag])
		}

		selectedTabBarButton = sender
	}

}
