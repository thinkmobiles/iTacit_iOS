//
//  MessagesViewController.swift
//  iTacit
//
//  Created by Sauron Black on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {

	private struct Constants {
		static let estimatedRowHeight = CGFloat(113)
	}

	@IBOutlet weak var tableView: UITableView!
	
    let messageList = MessageListModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.tableFooterView = UIView()
		tableView.estimatedRowHeight = Constants.estimatedRowHeight
		tableView.rowHeight = UITableViewAutomaticDimension
		messageList.load { [weak self] success in
			self?.tableView?.reloadData()
		}
	}

}

// MARK: - UITableViewDataSource

extension MessagesViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messageList.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("MessageTableViewCell", forIndexPath: indexPath) as! MessageTableViewCell
		let message = messageList[indexPath.item]
		cell.configureWithMessage(message)
		return cell
	}

}
