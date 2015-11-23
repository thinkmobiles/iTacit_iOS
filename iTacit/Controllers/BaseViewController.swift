//
//  BaseViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		addBackButton()
    }

	func addBackButton() {
		let backBarButton = UIBarButtonItem(image: UIImage(assetsIndetifier: .BackButton), style: .Plain, target: self, action: Selector("backButtonAction"))
		navigationItem.leftBarButtonItem = backBarButton
	}

    // MARK: - ButtonAction
    
    func backButtonAction() {
		didBack()
        navigationController?.popViewControllerAnimated(true)
    }

	func didBack() { }

    // MARK: - Keyboard
    
    func addKeyboardObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShowNotification:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHideNotification:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func getSizeAnimationDurationAndOptionsFromUserInfo(userInfo: [NSObject: AnyObject]) -> (CGSize, Double, UIViewAnimationOptions) {
        let size = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationOptionRaw = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16
        let animationOptions = UIViewAnimationOptions(rawValue: UInt(animationOptionRaw))
        return (size, animationDuration, animationOptions)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardInfo = getSizeAnimationDurationAndOptionsFromUserInfo(userInfo)
            keyboardWillShowWithSize(keyboardInfo.0, animationDuration: keyboardInfo.1, animationOptions: keyboardInfo.2)
        }
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardInfo = getSizeAnimationDurationAndOptionsFromUserInfo(userInfo)
            keyboardWillHideWithSize(keyboardInfo.0, animationDuration: keyboardInfo.1, animationOptions: keyboardInfo.2)
        }
    }
    
    func keyboardWillShowWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
        
    }
    
    func keyboardWillHideWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
        
    }

}

class NavigationController: UINavigationController {

	override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject?) -> UIViewController? {
		if fromViewController is FilterNewsViewController {
			return (viewControllers.first as? MainTabBarController)?.currentViewController
		} else {
			return super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
		}
	}
}

