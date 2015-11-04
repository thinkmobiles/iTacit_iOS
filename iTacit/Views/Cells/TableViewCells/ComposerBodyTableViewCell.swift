//
//  ComposerBodyTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ComposerBodyTableViewCell: UITableViewCell {

	static let reuseIdentifier = "ComposerBodyTableViewCell"

    var delegate: ComposeDynamicCellDelegate?

    @IBOutlet weak var bodyTextView: UITextView!
}

extension ComposerBodyTableViewCell: UITextViewDelegate {
	
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if !textView.text.isEmpty {
            if let _delegate = delegate {
                _delegate.composerCellTopicDidChangeTo(textView.text, cell: self)
            }
        }
        
        return true
    }
}