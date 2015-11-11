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
	}

	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var rightButton: UIButton!
	@IBOutlet weak var rightButtonWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!

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

	// MARK: - Private

	private func setUpDefault() {
		rightButtonWidthConstraint.constant = 0
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

	// MARK: - IBActions


	@IBAction func rightButtonAction() {
		if case .Deletable = style {
			delegate?.userProfileTableViewCellDidPressDeleteButton(self)
		}
	}
    
}
