//
//  ComposerRecipientsTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ComposerRecipientsTableViewCellDelegate: class {

	func composerRecipientsTableViewCellDidPressMoreButton(cell: ComposerRecipientsTableViewCell)
	func composerRecipientsTableViewCell(cell: ComposerRecipientsTableViewCell, didChangeSearchString searchString: String)
	func composerRecipientsTableViewCellDidBeginSearch(cell: ComposerRecipientsTableViewCell)

}

class ComposerRecipientsTableViewCell: UITableViewCell {

	typealias SuggestedItem = UserProfileModel

	static let reuseIdentifier = "ComposerRecipientsTableViewCell"

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var tagTextField: TagTextField!
	@IBOutlet weak var autocompletionTableView: UITableView!
	@IBOutlet weak var autocompletionTableViewHeightConstraint: NSLayoutConstraint!

	var autocompletionDataSource = [SuggestedItem]()
	let numberOfVisibleCells = 3

	weak var delegate: ComposerRecipientsTableViewCellDelegate?

	// MARK: - Lifecycle

	override func awakeFromNib() {
		super.awakeFromNib()
		titleLabel.text = LocalizedString("To:")
		layoutMargins = UIEdgeInsetsZero
		layer.zPosition = 666
		autocompletionTableView.registerNib(UserProfileTableViewCell.nib, forCellReuseIdentifier: UserProfileTableViewCell.ReuseIdentifier.Selectable.rawValue)
		autocompletionTableView.tableFooterView = UIView()
	}

	// MARK: - Public

	// MARK: - IBActions

	@IBAction func moreAction() {
		delegate?.composerRecipientsTableViewCellDidPressMoreButton(self)
	}

	@IBAction func tagTextFieldDidChageText(sender: TagTextField) {
		delegate?.composerRecipientsTableViewCell(self, didChangeSearchString: sender.text)
	}

	@IBAction func tagTextFieldDidBeginEditing(sender: TagTextField) {
		delegate?.composerRecipientsTableViewCellDidBeginSearch(self)
	}

	// MARK: - UIView

	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		let convertedPoint = autocompletionTableView.convertPoint(point, fromView: self)
		if CGRectContainsPoint(autocompletionTableView.bounds, convertedPoint) && autocompletionDataSource.count > 0 {
			return autocompletionTableView
		}
		return super.hitTest(point, withEvent: event)
	}

}


// MARK: - UITableViewDataSource

extension ComposerRecipientsTableViewCell: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return autocompletionDataSource.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(UserProfileTableViewCell.ReuseIdentifier.Selectable.rawValue, forIndexPath: indexPath) as! UserProfileTableViewCell
		let userProfile = autocompletionDataSource[indexPath.row]
		cell.fullName = userProfile.fullName
		cell.status = userProfile.status

		if let imageURL = userProfile.imageUrl {
			cell.imageDownloadTask?.cancel()
			cell.imageDownloadTask = ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { (image) -> Void in
				cell.profileImage = image
			})
		} else {
			cell.profileImageView.image = nil
		}

		return cell
	}

}

// MARK: - UITableViewDelegate

extension ComposerRecipientsTableViewCell: UITableViewDelegate {

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		hideAutocompletionTableView()
	}
	
}

//MARK: - Autocompletable

extension ComposerRecipientsTableViewCell: Autocompletable {

	func willShowAutocompletion() {
		superview?.bringSubviewToFront(self)
	}

	func shoudShowAutocompletion() -> Bool {
		return tagTextField.text.characters.count >= 3
	}

}
