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

	@IBOutlet weak var screenTitleLabel: UILabel!
	@IBOutlet weak var categoryFullNameLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var collectionView: UICollectionView!

	var messageCategories = [MessageCategoryModel]()
    let messageList = MessageListModel()
	let searchQuery = MessageSearchQueryModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpTableView()
		setUpMessageGroupList()
		messageList.searchQuery = searchQuery
		reloadData()
	}

	func setUpTableView() {
		tableView.tableFooterView = UIView()
		tableView.estimatedRowHeight = Constants.estimatedRowHeight
		tableView.rowHeight = UITableViewAutomaticDimension
	}

	func setUpMessageGroupList() {
		messageCategories = [MessageCategoryModel(category: .All),
							 MessageCategoryModel(category: .ActOn),
							 MessageCategoryModel(category: .Waiting),
							 MessageCategoryModel(category: .ToMe),
							 MessageCategoryModel(category: .FromMe)]
	}

	func reloadData() {
		messageList.load { [weak self] success in
			guard let strongSelf = self else {
				return
			}
			let index = strongSelf.messageCategories.indexOf { $0.category == strongSelf.searchQuery.category }
			if let index = index {
				strongSelf.messageCategories[index].count = strongSelf.messageList.count
				strongSelf.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
			}
			strongSelf.tableView.reloadData()
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

// MARK: - UICollectionViewDataSource

extension MessagesViewController: UICollectionViewDataSource {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messageCategories.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MessageCategoryCollectionViewCell.reuseIdentifeir, forIndexPath: indexPath) as! MessageCategoryCollectionViewCell
		let categoryModel = messageCategories[indexPath.item]
		cell.name = categoryModel.category.rawValue
		cell.count = categoryModel.count
		if categoryModel.category == searchQuery.category {
			cell.selected = true
			collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
		}
		return cell
	}

}

// MARK: - UICollectionViewDelegate

extension MessagesViewController: UICollectionViewDelegate {

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: false)
		let categoryModel = messageCategories[indexPath.item]
		categoryFullNameLabel.text = categoryModel.category.fullName
		searchQuery.category = categoryModel.category
		messageList.lastTask?.cancel()
		reloadData()
	}

}
