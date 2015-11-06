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

	private var readDate: NSDate?

	private var reuseIdetifiersDataSource = [ComposerRecipientsTableViewCell.reuseIdentifier, ComposerTopicTableViewCell.reuseIdentifier, ComposerBodyTableViewCell.reuseIdentifier]

    private var messageModel = NewMessageModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
		tableView.layoutMargins = UIEdgeInsetsZero
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

	// MARK: - Private

	private func deleteReadDateCell() {
		if let index = reuseIdetifiersDataSource.indexOf(ComposerReadDateTableViewCell.reuseIdentifier) {
			reuseIdetifiersDataSource.removeAtIndex(index)
			tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
		}
	}
    
    // MARK: - IBActions
    
    @IBAction func sendMessageAction(sender: UIBarButtonItem) {

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

	func tableVeiwCellNeedsUpdateSize(cell: UITableViewCell) {
		tableView.beginUpdates()
		tableView.endUpdates()
	}
}

// MARK: - ComposerRecipientsTableViewCellDelegate

extension MessageComposeViewController: ComposerRecipientsTableViewCellDelegate {

	func composerRecipientsTableViewCellDidPressMoreButton(cell: ComposerRecipientsTableViewCell) {

	}
}

// MARK: - ComposerReadDateTableViewCellDelegate

extension MessageComposeViewController: ComposerReadDateTableViewCellDelegate {

	func composerReadDateTableViewCellDidPressDeleteButton(cell: ComposerReadDateTableViewCell) {
		deleteReadDateCell()
		readDate = nil
	}

	func composerReadDateTableViewCell(cell: ComposerReadDateTableViewCell, didPickDate date: NSDate) {
		readDate = date
	}

}
