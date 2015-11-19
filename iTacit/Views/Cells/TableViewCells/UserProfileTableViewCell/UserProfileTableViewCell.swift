//
//  UserProfileTableViewCell.swift
//  iTacit
//
//  Created by Sauron Black on 11/9/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol UserProfileTableViewCellDelegate: class {

	func userProfileTableViewCellDidPressDeleteButton(cell: UserProfileTableViewCell)

}

class UserProfileTableViewCell: UITableViewCell {

	private struct Constants {
		static let rightButtonWidth = CGFloat(35)

	}

	static let reuseIdentifier = "UserProfileTableViewCell"

	enum Style {
		case Default
		case Selectable
		case Deletable
		case Confirmed
	}

	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var rightButton: UIButton!
	@IBOutlet weak var rightButtonWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var confirmedImageView: UIImageView!

	weak var delegate: UserProfileTableViewCellDelegate?

	var profileImage: UIImage? {
		get {
			return profileImageView.image
		}
		set {
			profileImageView.image = newValue
		}
	}

	var fullName: String {
		get {
			return fullNameLabel.text ?? ""
		}
		set {
			fullNameLabel.text = newValue
		}
	}

	var status: String {
		get {
			return statusLabel.text ?? ""
		}
		set {
			statusLabel.text = newValue
		}
	}

	var imageDownloadTask: NSURLSessionTask? {
		didSet {
			if let _ = imageDownloadTask {
				profileImage = nil
			}
		}
	}

	var style = Style.Default {
		didSet {
			switch style {
				case .Default: setUpDefault()
				case .Selectable: setUpSelectable()
				case .Deletable: setUpDeletable()
				case .Confirmed: setUpConfirmed()
			}
		}
	}

	var separatorHidden: Bool {
		get {
			return separatorView.hidden
		}
		set {
			separatorView.hidden = newValue
		}
	}

	var imageOffset: CGFloat {
		get {
			return imageViewLeadingConstraint.constant
		}
		set {
			imageViewLeadingConstraint.constant = newValue
		}
	}

	class var nib: UINib {
		return UINib(nibName: "UserProfileTableViewCell", bundle: nil)
	}

	// MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
		layoutMargins = UIEdgeInsetsZero
		setUpDefault()
    }

	override func prepareForReuse() {
		super.prepareForReuse()
		rightButton.selected = false
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		if case .Selectable = style {
			rightButton.selected = selected
		}
    }

	// MARK: - Public 

	func configureWithUserProfile(userProfile: UserProfileModel) {
		configureWithFullName(userProfile.fullName, status: userProfile.status, imageURL: userProfile.imageURL)
	}

	func configureWithFullName(fullName: String, status: String, imageURL: NSURL?) {
		self.fullName = fullName
		self.status = status

		if let imageURL = imageURL {
			imageDownloadTask?.cancel()
			profileImage = nil
			imageDownloadTask = ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { [weak self] (image) -> Void in
				self?.profileImage = image
				})
		} else {
			profileImage = nil
		}
	}

	// MARK: - Private

	private func setUpDefault() {
		rightButtonWidthConstraint.constant = 0
		confirmedImageView.hidden = true
	}

	private func setUpSelectable() {
		rightButton.setImage(UIImage(assetsIndetifier: .UnselectedIcon), forState: .Normal)
		rightButton.setImage(UIImage(assetsIndetifier: .SelectedIcon), forState: .Selected)
		rightButtonWidthConstraint.constant = Constants.rightButtonWidth
		rightButton.userInteractionEnabled = false
	}

	private func setUpDeletable() {
		rightButton.setImage(UIImage(assetsIndetifier: .CloseIcon), forState: .Normal)
		rightButtonWidthConstraint.constant = Constants.rightButtonWidth
		rightButton.userInteractionEnabled = true
	}

	private func setUpConfirmed() {
		rightButton.hidden = true
		confirmedImageView.hidden = false
		rightButtonWidthConstraint.constant = Constants.rightButtonWidth
	}

	// MARK: - IBActions


	@IBAction func rightButtonAction() {
		if case .Deletable = style {
			delegate?.userProfileTableViewCellDidPressDeleteButton(self)
		}
	}
    
}
