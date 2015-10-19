//
//  UserTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/16/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    private struct Constants {
        static let selectButtonWidth: CGFloat = 20
    }
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var selectAuthorButton: UIButton!
    @IBOutlet weak var selectAuthorButtonWidthConstraint: NSLayoutConstraint!
    
    var selectable: Bool? {
        get {
            return self.selectable
        }
        set {
            if newValue == true {
                selectAuthorButtonWidthConstraint.constant = Constants.selectButtonWidth
            } else {
                selectAuthorButtonWidthConstraint.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectAuthorButton.selected = selected
    }

}
