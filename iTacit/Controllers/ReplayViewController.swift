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
    var replyMessageModel = MessageCreateReplyModel()
    var message: MessageModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObservers()
        prepareUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        bodyTextView.becomeFirstResponder()
    }
    
    deinit {
        removeKeyboardObservers()
    }

    // MARK: - IBAction
    
    @IBAction func sendButtonAction(sender: UIBarButtonItem) {
        if !prepareReply() {
            return
        }
        
        replyMessageModel.sendReply { [unowned self] (success) -> Void in
            if success {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
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
    
    func prepareReply() -> Bool {
//        var messageId = ""
//        var senderID = ""
//        var privateReply = false
//        var body: NSAttributedString?
        replyMessageModel.senderID = "1"
        replyMessageModel.messageId = message.id
        replyMessageModel.body = NSAttributedString(string: bodyTextView.text)
        switch replayType {
        case .ToAll: replyMessageModel.privateReply = false
        case .ToUser(_): replyMessageModel.privateReply = true
        }
        
        return true
    }

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
