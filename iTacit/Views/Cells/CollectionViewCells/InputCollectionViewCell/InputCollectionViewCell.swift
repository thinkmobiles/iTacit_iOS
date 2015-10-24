//
//  InputCollectionViewCell.swift
//  TagsSearchControl
//
//  Created by Sauron Black on 10/16/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol InputCollectionViewCellDelegate: class {

	func inputCollectionViewCellDidChangeText(cell: InputCollectionViewCell)
	func didTapInInputCollectionViewCell(cell: InputCollectionViewCell)
	
}

class InputCollectionViewCell: UICollectionViewCell {

	static let reuseIdentifier = "InputCollectionViewCell"

	@IBOutlet weak var textField: UITextField!

	weak var delegate: InputCollectionViewCellDelegate?

	var text: String {
		get {
			return textField.text ?? ""
		}
		set {
			textField.text = newValue
		}
	}

	var cursorColor: UIColor {
		get {
			return textField.tintColor
		}
		set {
			textField.tintColor = newValue
		}
	}

	// MARK: - Lifecycle

	override func awakeFromNib() {
		super.awakeFromNib()
		textField.tintColor = AppColors.darkGray
		let gesture = UITapGestureRecognizer(target: self, action: Selector("tapInTextField:"))
		gesture.delegate = self
		textField.addGestureRecognizer(gesture)
	}

	// MARK: - Public

	func resetTextField() {
		textField.text = ""
		textField.tintColor = AppColors.darkGray
	}

	// MARK: - IBAction

	@IBAction func didChangeText() {
		delegate?.inputCollectionViewCellDidChangeText(self)
	}

	@IBAction func tapInTextField(sender: UITapGestureRecognizer) {
		delegate?.didTapInInputCollectionViewCell(self)
	}

}

extension InputCollectionViewCell: UIGestureRecognizerDelegate {

	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
