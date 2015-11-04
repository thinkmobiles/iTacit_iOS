//
//  ComposerTopicTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ComposeDynamicCellDelegate: class {

    func composerCellTopicDidChangeTo(newValue: AnyObject, cell: UITableViewCell)
	
}

class ComposerTopicTableViewCell: UITableViewCell {

	static let reuseIdentifier = "ComposerTopicTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topicText: UITextView!
    
    var delegate: ComposeDynamicCellDelegate?
    var messageModel: NewMessageModel? {
        didSet {
            reloadUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func reloadUI() {
        topicText.text = messageModel?.topic ?? ""
    }
}

extension ComposerTopicTableViewCell: UITextViewDelegate {

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if !textView.text.isEmpty {
			delegate?.composerCellTopicDidChangeTo(textView.text, cell: self)
        }
        
        return true
    }
}