//
//  MessagesViewController.swift
//  iTacit
//
//  Created by Sauron Black on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessagesViewController: PagingViewController {

	private struct Constants {
		static let estimatedRowHeight = CGFloat(113)
	}

	@IBOutlet weak var screenTitleLabel: UILabel!
	@IBOutlet weak var categoryFullNameLabel: UILabel!
	@IBOutlet weak var tagSearchControl: TagSearchControl!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var cancelSearchButton: UIButton!
	@IBOutlet weak var tagSearchControlTopConstraint: NSLayoutConstraint!

	private var searchControlActive = false
	private var searchTimer: NSTimer?

	var messageCategories = [MessageCategoryModel]()
    let messageList = MessageListModel()
	let searchQuery = MessageSearchQueryModel()

	// MARK: - LifeCycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpTableView()
		setUpMessageGroupList()
		messageList.searchQuery = searchQuery
		setUpSearchControl()
		reloadData()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		addKeyboardObservers()
		clearSelection()
		reloadData()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		removeKeyboardObservers()
	}

	// MARK: - Private

	private func setUpTableView() {
		tableView.tableFooterView = UIView()
		tableView.estimatedRowHeight = Constants.estimatedRowHeight
		tableView.rowHeight = UITableViewAutomaticDimension
	}

	private func setUpMessageGroupList() {
		messageCategories = [MessageCategoryModel(category: .All),
							 MessageCategoryModel(category: .ActOn),
							 MessageCategoryModel(category: .Waiting),
							 MessageCategoryModel(category: .ToMe),
							 MessageCategoryModel(category: .FromMe),
							 MessageCategoryModel(category: .Archive)]
		categoryFullNameLabel.text = messageCategories[0].category.fullName
	}

	private func setUpSearchControl() {
		tagSearchControl.delegate = self
		tagSearchControl.tagTextField.edgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
		tagSearchControl.allowActivation = false
	}

	private func setCountForCurrentCategory(count: Int) {
		let index = messageCategories.indexOf { $0.category == searchQuery.category }
		if let index = index {
			messageCategories[index].count = count
			collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
		}
	}

	private func clearSelection() {
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
		}
	}

	private func activateSearchControl() {
		guard !searchControlActive else {
			return
		}

		searchControlActive = true

		view.layoutIfNeeded()
		UIView.animateKeyframesWithDuration(0.25, delay: 0.0, options: .CalculationModeLinear, animations: { [unowned self] in
			UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.8) { [unowned self] in
				self.tagSearchControlTopConstraint.constant += CGRectGetHeight(self.tagSearchControl.frame)
				self.view.layoutIfNeeded()
			}

			UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.2) { [unowned self] in
				self.tagSearchControl.topSeparatorView.alpha = 1.0
				self.cancelSearchButton.alpha = 1.0
			}
		}) { [unowned self] finished in
			self.tagSearchControl.allowActivation = true
			self.tagSearchControl.beginEditing()
		}
	}

	private func disactivateSearchControl() {
		guard searchControlActive else {
			return
		}

		searchControlActive = false
		tagSearchControl.allowActivation = false
		tagSearchControl.clear()

		view.layoutIfNeeded()
		UIView.animateKeyframesWithDuration(0.25, delay: 0.0, options: .CalculationModeLinear, animations: { [unowned self] in
			UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.2) { [unowned self] in
				self.tagSearchControl.topSeparatorView.alpha = 0.0
				self.cancelSearchButton.alpha = 0.0
			}

			UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.8) { [unowned self] in
				self.tagSearchControlTopConstraint.constant -= CGRectGetHeight(self.tagSearchControl.frame)
				self.view.layoutIfNeeded()
			}
		}, completion: nil)
	}

	// MARK: - Data reloading

	override var numberOfItems: Int {
		return messageList.count
	}

	override var rowHeight: CGFloat {
		return Constants.estimatedRowHeight
	}

	override func reloadData() {
		super.reloadData()
		messageList.load { [weak self] success in
			self?.didLoadData()
		}
	}

	override func loadMoreItems() {
		messageList.loadMore { [weak self] (success) -> Void in
			self?.didLoadData()
		}
	}

	private func didLoadData() {
		setCountForCurrentCategory(messageList.count)
		tableView.reloadData()
	}

	// MARK: - Keyboard

	override func keyboardWillShowWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
	}

	override func keyboardWillHideWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
		tableView.contentInset = UIEdgeInsetsZero
	}

	// MARK: - IBActions

	@IBAction func cancelSearchAction() {
		disactivateSearchControl()
	}

	@IBAction func didChangeSearchString(sender: TagSearchControl) {
		searchQuery.string = sender.searchText.characters.count >= 3 ? tagSearchControl.searchText: ""
		searchTimer?.invalidate()
		searchTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("reloadData"), userInfo: nil, repeats: false)
	}

	// MARK: - Navigation 

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let selectedIndexPath = tableView.indexPathForSelectedRow,  messageDetailViewController = segue.destinationViewController as? MessageDetailViewController {
			messageDetailViewController.message = messageList[selectedIndexPath.row]
		}
	}

}

// MARK: - UITableViewDataSource

extension MessagesViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messageList.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(MessageTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! MessageTableViewCell
		cell.swipeEnabled = (searchQuery.category != .Archive)
		let message = messageList[indexPath.item]
		cell.configureWithMessage(message)
		cell.delegate = self
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

// MARK: - TagSearchControlDelegate

extension MessagesViewController: TagSearchControlDelegate {

	func tagsSearchControlSearchButtonPressed(tagsSearchControl: TagSearchControl) {
		searchTimer?.invalidate()
		reloadData()
	}

	func tagsSearchControlDidClear(tagsSearchControl: TagSearchControl) {
		searchTimer?.invalidate()
		searchQuery.string = ""
		reloadData()
	}

	func tagsSearchControlShouldBecameActive(tagsSearchControl: TagSearchControl) -> Bool {
		activateSearchControl()
		return false
	}

}

// MARK: - MessageTableViewCellDelegate

extension MessagesViewController: MessageTableViewCellDelegate {

	func messageTableViewCellDidPressArchiveButton(cell: MessageTableViewCell) {
		if let indexPath = tableView.indexPathForCell(cell) {
			let message = messageList[indexPath.row]
			message.archive()
			messageList.objects.removeAtIndex(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			setCountForCurrentCategory(messageList.count)
		}
	}

}
