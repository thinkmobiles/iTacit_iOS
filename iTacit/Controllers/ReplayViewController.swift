//
//  ReplayViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/11/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ReplayViewController: BaseViewController {
    
    enum ReplayType {
        case ToAll
        case ToUser(user: UserProfileModel)
    }
    
    private struct Constants {
        static let defaultBottomHeight: CGFloat = 8.0
    }
    
    @IBOutlet weak var replyDescription: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingImageLabel: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var replayType: ReplayType = .ToAll

    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObservers()
        prepareUI()
    }
    
    deinit {
        removeKeyboardObservers()
    }

    // MARK: - Keyboard
    
    override func keyboardWillShowWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
        if bottomConstraint.constant != Constants.defaultBottomHeight {
            return
        }
        
        bottomConstraint.constant += size.height
    }
    
    override func keyboardWillHideWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
        bottomConstraint.constant = Constants.defaultBottomHeight
    }
    
    // MARK: - Private

    func prepareUI() {
        switch replayType {
            case .ToAll: prepareAppearenceWithUser(nil)
            case .ToUser(let user): prepareAppearenceWithUser(user)
        }
    }
    
    func prepareAppearenceWithUser(userModel: UserProfileModel?) {
        if let user = userModel {
            replyDescription.text = LocalizedString("This is private reply to ") + user.firstName
            navigationItem.title = LocalizedString("Reply to") + user.firstName
        } else {
            navigationItem.title = LocalizedString("Reply to All")
            replyDescription.text = LocalizedString("This reply will be seen by all recipients")
            imageWidthConstraint.constant = 0
            spacingImageLabel.constant = 0
        }
    }
	
}
