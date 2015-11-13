//
//  MessageCategoryCollectionViewCell.swift
//  iTacit
//
//  Created by Sauron Black on 11/13/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessageCategoryCollectionViewCell: UICollectionViewCell {

	static let reuseIdentifeir = "MessageCategoryCollectionViewCell"

	private class Constants {
		static let grayColor = UIColor(hexColor: 0xA8A8A8)
		static let borderWidth = CGFloat(0.5)
	}

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var countLabel: UILabel!

	var name: String {
		get {
			return nameLabel.text ?? ""
		}
		set {
			nameLabel.text = newValue
		}
	}

	var count: Int {
		get {
			return ((nameLabel.text ?? "") as NSString).integerValue
		}
		set {
			countLabel.text = "\(newValue)"
		}
	}

	override var selected: Bool {
		didSet {
			layer.borderWidth = selected ? 0: Constants.borderWidth
			backgroundColor = selected ? AppColors.blue: UIColor.whiteColor()
			nameLabel.textColor = selected ? UIColor.whiteColor(): Constants.grayColor
			countLabel.textColor = selected ? UIColor.whiteColor(): AppColors.darkGray
		}
	}
}
