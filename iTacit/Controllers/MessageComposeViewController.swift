//
//  MessageComposeViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessageComposeViewController: BaseViewController {
    
    private struct Constants {
        static let defaultCellHeight: CGFloat = 42.0
        static let floatingViewBottomSpace: CGFloat = 9.0
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var floatingViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var floatingCalendarButton: UIButton!

	private weak var recipientsTableViewCell: ComposerRecipientsTableViewCell?
	private weak var topicTableViewCell: ComposerTopicTableViewCell?
	private weak var readDateTableViewCell: ComposerReadDateTableViewCell?
	private weak var bodyTableViewCell: ComposerBodyTableViewCell?

	private var searchTimer: NSTimer?

	private var reuseIdetifiersDataSource = [ComposerRecipientsTableViewCell.reuseIdentifier, ComposerTopicTableViewCell.reuseIdentifier, ComposerBodyTableViewCell.reuseIdentifier]

	private var message = NewMessageModel()
	private var userProfileList = UserProfileListModel()

	// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
		tableView.layoutMargins = UIEdgeInsetsZero
		userProfileList.searchQuery = SearchStringModel(string: "")
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didUpdateRecipientsNotification:"), name: NewMessageModel.Notifications.DidUpdateRecipients, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let radius = CGRectGetMidY(floatingCalendarButton.bounds)
		floatingCalendarButton.roundCorners([.TopLeft, .BottomLeft], radii: CGSize(width: radius, height: radius))
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NewMessageModel.Notifications.DidUpdateRecipients, object: nil)
	}

	// MARK: - Private

	private func deleteReadDateCell() {
		if let index = reuseIdetifiersDataSource.indexOf(ComposerReadDateTableViewCell.reuseIdentifier) {
			reuseIdetifiersDataSource.removeAtIndex(index)
			tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
		}
	}

	func performSearch(sender: NSTimer) {
		userProfileList.load { [weak self] (success) -> Void in
			self?.updateAutocompletionList()
		}
	}

	private func updateAutocompletionList() {
		recipientsTableViewCell?.updateDataSource(userProfileList.objects)
	}

	private func updateSendButtonState() {
		do {
			try message.validate()
			navigationItem.rightBarButtonItem?.enabled = true
		} catch {
			navigationItem.rightBarButtonItem?.enabled = false
		}
	}

	// MARK: - Notifications

	func didUpdateRecipientsNotification(notification: NSNotification) {
		updateSendButtonState()
	}

    // MARK: - IBActions
    
    @IBAction func sendMessageAction(sender: UIBarButtonItem) {
		sender.enabled = false
		do {
			try message.send { [weak self] success -> Void in
				if success {
					self?.navigationController?.popViewControllerAnimated(true)
				} else {
					sender.enabled = true
				}
			}
		} catch {
			print("Failed send message because of error: \(error)")
		}
    }
    
    @IBAction func showDatePickerAction() {
		if !reuseIdetifiersDataSource.contains(ComposerReadDateTableViewCell.reuseIdentifier) {
			let index = 2
			reuseIdetifiersDataSource.insert(ComposerReadDateTableViewCell.reuseIdentifier, atIndex: index)
			tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
		} else {
			readDateTableViewCell?.showDatePicker()
		}
    }

	@IBAction func returnFromAddRecipientsViewController(segue: UIStoryboardSegue) {
		if let addRecipientViewController = segue.sourceViewController as? AddRecipientViewController {
			message.recipients = addRecipientViewController.recipients
			print("Recipients: \(message.recipients)")
		}
	}
    
    // MARK: Keyboard
    
    override func keyboardWillShowWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
		let bottomOffset = size.height
		let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomOffset, right: 0.0)
		view.layoutIfNeeded()
		UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: { [weak self] () -> Void in
			self?.tableView.contentInset = contentInsets
			self?.tableView.scrollIndicatorInsets = contentInsets
			self?.floatingViewBottomConstraint.constant = size.height + Constants.floatingViewBottomSpace
			self?.view.layoutIfNeeded()
		}, completion: nil)
    }
    
    override func keyboardWillHideWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
		view.layoutIfNeeded()
		UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: { [weak self] () -> Void in
			self?.tableView.contentInset = UIEdgeInsetsZero
			self?.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
			self?.floatingViewBottomConstraint.constant = Constants.floatingViewBottomSpace
			self?.view.layoutIfNeeded()
		}, completion: nil)
	}

	// MARK: - Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let addRecipientViewController = segue.destinationViewController as? AddRecipientViewController {
			addRecipientViewController.recipients = message.recipients
		}
	}

}

// MARK: - UITableViewDataSource

extension MessageComposeViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reuseIdetifiersDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let reuseIdentifier = reuseIdetifiersDataSource[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
		if let cell = cell as? ComposerRecipientsTableViewCell {
			recipientsTableViewCell = cell
			recipientsTableViewCell?.delegate = self
		} else if let cell = cell as? ComposerTopicTableViewCell {
			topicTableViewCell = cell
			topicTableViewCell?.delegate = self
		} else if let cell = cell as? ComposerReadDateTableViewCell {
			readDateTableViewCell = cell
			readDateTableViewCell?.delegate = self
			readDateTableViewCell?.showDatePicker()
		} else if let cell = cell as? ComposerBodyTableViewCell {
			bodyTableViewCell = cell
			bodyTableViewCell?.delegate = self
		}
		return cell
    }
	
}

// MARK: - UITableViewDelegate

extension MessageComposeViewController: UITableViewDelegate {

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.item == 0 {
			return recipientsTableViewCell?.height ?? Constants.defaultCellHeight
		}
		let targetSize = CGSize(width: CGRectGetWidth(tableView.frame), height: Constants.defaultCellHeight)
		if indexPath.item == 1 {
			if let size = topicTableViewCell?.systemLayoutSizeFittingSize(targetSize, withHorizontalFittingPriority: 1000, verticalFittingPriority: 50) {
				return max(size.height, Constants.defaultCellHeight)
			}
		} else if indexPath.item == reuseIdetifiersDataSource.count - 1 {
			if let size = bodyTableViewCell?.systemLayoutSizeFittingSize(targetSize, withHorizontalFittingPriority: 1000, verticalFittingPriority: 50) {
				return max(size.height, Constants.defaultCellHeight)
			}
		}
		return Constants.defaultCellHeight
	}

}

// MARK: - ResizableTableViewCellDelegate

extension MessageComposeViewController: ResizableTableViewCellDelegate {

	func tableViewCellNeedsUpdateSize(cell: UITableViewCell) {
		tableView.beginUpdates()
		tableView.endUpdates()
	}

	func tableViewCell(cell: ResizableTableViewCell, didChangeText text: String) {
		if let topicTableViewCell = topicTableViewCell where topicTableViewCell == cell {
			message.subject = topicTableViewCell.topic
		} else if let bodyTableViewCell = bodyTableViewCell where bodyTableViewCell == cell {
			message.body = NSAttributedString(string: bodyTableViewCell.string)
		}
		updateSendButtonState()
	}

}

// MARK: - ComposerRecipientsTableViewCellDelegate

extension MessageComposeViewController: ComposerRecipientsTableViewCellDelegate {

	func composerRecipientsTableViewCellDidPressMoreButton(cell: ComposerRecipientsTableViewCell) {

	}

	func composerRecipientsTableViewCell(cell: ComposerRecipientsTableViewCell, didChangeSearchString searchString: String) {
		(userProfileList.searchQuery as? SearchStringModel)?.string = searchString
		searchTimer?.invalidate()
		searchTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("performSearch:"), userInfo: nil, repeats: false)
	}

	func composerRecipientsTableViewCellDidBeginSearch(cell: ComposerRecipientsTableViewCell) {
		updateAutocompletionList()
	}

	func composerRecipientsTableViewCellNeedsUpdateSize(cell: ComposerRecipientsTableViewCell) {
		tableView.beginUpdates()
		tableView.endUpdates()
	}

	func composerRecipientsTableViewCell(cell: ComposerRecipientsTableViewCell, didAddUser userProfile: UserProfileModel) {
		message.recipients.append(NewMessageModel.Recipient.Employee(userProfile: userProfile))
	}

	func composerRecipientsTableViewCell(cell: ComposerRecipientsTableViewCell, didRemoveUserWithId userId: String) {
		let index = message.recipients.indexOf { (recipient) -> Bool in
			if case .Employee(let userProfile) = recipient {
				return userProfile.id == userId
			}
			return false
		}
		if let index = index {
			message.recipients.removeAtIndex(index)
		}
	}

}

// MARK: - ComposerReadDateTableViewCellDelegate

extension MessageComposeViewController: ComposerReadDateTableViewCellDelegate {

	func composerReadDateTableViewCellDidPressDeleteButton(cell: ComposerReadDateTableViewCell) {
		deleteReadDateCell()
		message.readRequirementType = .NotRequired
	}

	func composerReadDateTableViewCell(cell: ComposerReadDateTableViewCell, didPickDate date: NSDate) {
		message.readRequirementType = .RequiredTo(date: date)
	}

}
