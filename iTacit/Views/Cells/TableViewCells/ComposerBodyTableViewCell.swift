//
//  ComposerBodyTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ComposerBodyTableViewCell: ResizableTableViewCell {

	static let reuseIdentifier = "ComposerBodyTableViewCell"

	override func awakeFromNib() {
		super.awakeFromNib()
		layoutMargins = UIEdgeInsetsZero
	}
}

