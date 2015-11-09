//
//  AddRecipientHeaderView.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/6/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class AddRecipientHeaderView: UIView {
    
    private struct Constants {
        static let NibName = "AddRecipientHeaderView"
        static let ExpandViewEmptyWidth: CGFloat = 33
        static let ExpandViewNormalWidth: CGFloat = 44
        static let ExpandViewImageNormalWidth: CGFloat = 12
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var expandImageView: UIImageView!
    @IBOutlet weak var expandViewWidthCinstraint: NSLayoutConstraint!
    @IBOutlet weak var expandViewImageWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: ComposerHeaderViewDelegate?
    var section: Int?
    var rowCount: String {
        get {
            return counterLabel.text ?? ""
        }
        set {
            counterLabel.text = newValue
            expandViewWidthCinstraint.constant = Constants.ExpandViewNormalWidth
            expandViewImageWidthConstraint.constant = Constants.ExpandViewImageNormalWidth

            if Int(newValue) == 0 {
                expandImageView.hidden = true
                expandViewWidthCinstraint.constant = Constants.ExpandViewEmptyWidth
                expandViewImageWidthConstraint.constant = 0
            }
        }
    }
    var isExpanded = false {
        didSet {
            if isExpanded {
                expandImageView.image = UIImage(assetsIndetifier: .TrianglePointerUp)
            } else  {
                expandImageView.image = UIImage(assetsIndetifier: .TrianglePointerDown)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    // MARK: - Private
    
    func loadViewFromNib() {
        if let view = NSBundle.mainBundle().loadNibNamed(Constants.NibName, owner: self, options: nil).first as? UIView {
            addEdgePinnedSubview(view)
        }
    }
    
    @IBAction func expandButtonAction(sender: UIButton) {
        delegate?.didSelectExpandButtonInHeaderView(self)
    }
}
