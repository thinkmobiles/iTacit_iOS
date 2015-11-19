//
//  ResizableTableViewCell.swift
//  iTacit
//
//  Created by Sauron Black on 11/5/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

@objc protocol ResizableTableViewCellDelegate: class {

	func tableViewCellNeedsUpdateSize(cell: UITableViewCell)
	optional func tableViewCell(cell: ResizableTableViewCell, didChangeText text: String)
}

class ResizableTableViewCell: UITableViewCell, UITextViewDelegate {

	@IBOutlet weak var textView: UITextView!

	weak var delegate: ResizableTableViewCellDelegate?

	var string: String {
		get {
			return textView.text ?? ""
		}
		set {
			textView.text = newValue
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		textView.textContainerInset = UIEdgeInsetsZero
		textView.textContainer.lineFragmentPadding = 0.0
		textView.contentInset = UIEdgeInsetsZero
		layoutMargins = UIEdgeInsetsZero
	}

	// MARK: - UITextViewDelegate

	func textViewDidChange(textView: UITextView) {
		let targetSize = CGSize(width: CGRectGetWidth(textView.frame), height: CGFloat.max)
		let textHeight = textView.sizeThatFits(targetSize).height
		let height = CGRectGetHeight(textView.frame)
		if height != textHeight {
			delegate?.tableViewCellNeedsUpdateSize(self)
		}
		delegate?.tableViewCell?(self, didChangeText: textView.text)
	}
	
}

