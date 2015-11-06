//
//  UserRecepientTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/4/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

enum UserRecepientCellType {
    case Default, Interactive
}

class UserRecepientTableViewCell: UITableViewCell {
    
    private struct Constants {
        static let defaultLeadingSize: CGFloat = 35.0
        static let interactiveLeadingSize: CGFloat = 19.0
        static let closeButtonWidth: CGFloat = 20.0
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userCredentialLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    
    weak var delegate: ComposerHeaderViewDelegate?
    
    var cellType: UserRecepientCellType? {
        didSet {
            if let type = cellType {
                switch type {
                case .Default: prepareCellLikeDefault()
                case .Interactive: prepareCellLikeInteractive()
                }
            }
        }
    }
    var hiddenSeparator: Bool {
        get {
            return separatorView.hidden
        }
        set {
            separatorView.hidden = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func closeButtonAction(sender: UIButton) {
        delegate?.didSelectCloseButtonInHeaderView(self)
    }
    
    private func prepareCellLikeDefault() {
        userImageLeadingConstraint.constant = Constants.defaultLeadingSize
        closeButton.hidden = true
        closeButtonWidthConstraint.constant = 0
        separatorView.hidden = true
    }
    
    private func prepareCellLikeInteractive() {
        userImageLeadingConstraint.constant = Constants.interactiveLeadingSize
        closeButton.hidden = false
        closeButtonWidthConstraint.constant = Constants.closeButtonWidth
        separatorView.hidden = false
    }
}
