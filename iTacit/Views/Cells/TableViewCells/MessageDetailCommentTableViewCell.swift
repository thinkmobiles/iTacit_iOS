//
//  MessageDetailCommentTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/13/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessageDetailCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var credentialLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var securityImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - IBAction
    
    @IBAction func replyButtonAction(sender: UIButton) {
    }
}
