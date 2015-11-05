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

}

class ComposerRecipientsTableViewCell: UITableViewCell {

	static let reuseIdentifier = "ComposerRecipientsTableViewCell"

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var tagTextField: TagTextField!

	weak var delegate: ComposerRecipientsTableViewCellDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		titleLabel.text = LocalizedString("To:")
		layoutMargins = UIEdgeInsetsZero
	}

	@IBAction func moreAction() {
		delegate?.composerRecipientsTableViewCellDidPressMoreButton(self)
	}

}
