//
//  ComposerTopicTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ComposerTopicTableViewCell: ResizableTableViewCell {

	static let reuseIdentifier = "ComposerTopicTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!

	var topic: String {
		get {
			return textView.text ?? ""
		}
		set {
			textView.text = newValue
		}
	}
    
    override func awakeFromNib() {
        super.awakeFromNib()
		titleLabel.text = LocalizedString("Topic:")
		layoutMargins = UIEdgeInsetsZero
    }
}
