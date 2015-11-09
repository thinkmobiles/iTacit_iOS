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

	enum ReuseIdentifier: String {
		case Default = "UserProfileTableViewCellDefalt"
		case Selectable = "UserProfileTableViewCellSelectable"
		case Deletable = "UserProfileTableViewCellDeletable"
	}

	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var rightButton: UIButton!
	@IBOutlet weak var rightButtonWidthConstraint: NSLayoutConstraint!

	weak var delegate: UserProfileTableViewCellDelegate?

	var identifier: ReuseIdentifier? {
		if let reuseIdentifierRaw = reuseIdentifier {
			return ReuseIdentifier(rawValue: reuseIdentifierRaw)
		}
		return nil
	}

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

	class var nib: UINib {
		return UINib(nibName: "UserProfileTableViewCell", bundle: nil)
	}

	// MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
		layoutMargins = UIEdgeInsetsZero
		if let identifier = identifier {
			switch identifier {
				case .Default: setUpDefault()
				case .Selectable: setUpSelectable()
				case .Deletable: setUpDeletable()
			}
		}
    }

	override func prepareForReuse() {
		super.prepareForReuse()
		rightButton.selected = false
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		rightButton.selected = selected
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
		if let identifier = identifier where identifier == .Deletable {
			delegate?.userProfileTableViewCellDidPressDeleteButton(self)
		}
	}
    
}
