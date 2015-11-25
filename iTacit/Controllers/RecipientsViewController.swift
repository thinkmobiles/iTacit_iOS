//
//  RecipientsViewController.swift
//  iTacit
//
//  Created by Sauron Black on 11/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class RecipientsViewController: BaseViewController {

	@IBOutlet weak var tableView: UITableView!

	private var numberOfLoadedElements = 0
	private var userRecipients: [NewMessageModel.Recipient] = []

	var recipientList: RecipientListModel<RecipientModel>?
	var path: RecipientListPath?
	var recipients: [NewMessageModel.Recipient] = [] {
		didSet {
			userRecipients = recipients.filter { (recipient) -> Bool in
				if case .Employee(_) = recipient {
					return true
				} else {
					return false
				}
			}
		}
	}

	// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.registerNib(UserProfileTableViewCell.nib, forCellReuseIdentifier: UserProfileTableViewCell.reuseIdentifier)
		tableView.tableFooterView = UIView()
		if let recipientList = recipientList {
			path = recipientList.recipientListPath
			navigationItem.rightBarButtonItem = nil
		} else if let path = path {
			recipientList = RecipientListModel<RecipientModel>(path: path)
			recipientList?.setRecipients(recipients)
			reloadData()
		}
		updateTitle()
    }

	// MARK: - Private

	private func updateTitle() {
		title = LocalizedString("Recipients") + " (\(recipientList?.count ?? 0))"
	}

	private func reloadData() {
		numberOfLoadedElements = 0
		recipientList?.load { [weak self] (success) -> Void in
			self?.updateTitle()
			self?.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
		}
	}

}

// MARK: - UITableViewDataSource

extension RecipientsViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return recipientList?.count ?? 0
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(UserProfileTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! UserProfileTableViewCell
		if let recipient = recipientList?[indexPath.row] {
			cell.configureWithFullName(recipient.fullName, status: recipient.status, imageURL: recipient.imageURL)
			cell.separatorInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 17)
			cell.delegate = self
			if let path = path where path == .AdvancedLookUpFullList {
				let isUserRecipient = userRecipients.contains { element -> Bool in
					if case .Employee(let user) = element where user.id == recipient.id {
						return true
					}
					return false
				}
				cell.style = isUserRecipient ? .Deletable : .Default
			} else {
				cell.style = recipient.hasConfirmed ? .Confirmed : .Default
			}
		}
		return cell
	}

}

extension RecipientsViewController: UserProfileTableViewCellDelegate {

	func userProfileTableViewCellDidPressDeleteButton(cell: UserProfileTableViewCell) {
		if let indexPath = tableView.indexPathForCell(cell), recipient = recipientList?[indexPath.row] {
			let index = recipients.indexOf { (element) -> Bool in
				if case .Employee(let user) = element where user.id == recipient.id {
					return true
				} else {
					return false
				}
			}
			if let index = index {
				recipients.removeAtIndex(index)
				recipientList?.setRecipients(recipients)
				reloadData()
			}
		}
	}

}
