//
//  ResizableTableViewCell.swift
//  iTacit
//
//  Created by Sauron Black on 11/5/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ResizableTableViewCellDelegate: class {

	func tableVeiwCellNeedsUpdateSize(cell: UITableViewCell)

}

class ResizableTableViewCell: UITableViewCell, UITextViewDelegate {

	@IBOutlet weak var textView: UITextView!

	weak var delegate: ResizableTableViewCellDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		textView.textContainerInset = UIEdgeInsetsZero
		textView.textContainer.lineFragmentPadding = 0.0
		layoutMargins = UIEdgeInsetsZero
	}

	// MARK: - UITextViewDelegate

	func textViewDidChange(textView: UITextView) {
		guard let attributedText = textView.attributedText, delegate = delegate else {
			return
		}

		let size = attributedText.boundingRectWithSize(CGSize(width: CGRectGetWidth(textView.frame), height: CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil).size
		if abs(size.height - CGRectGetHeight(textView.frame)) > 1.0 {
			delegate.tableVeiwCellNeedsUpdateSize(self)
		}
	}
	
}

