//
//  ComposeReportsHeaderView.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/5/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ComposerHeaderViewDelegate: class {
    func didSelectExpandButtonInHeaderView(view: UIView)
    func didSelectCloseButtonInHeaderView(view: UIView)
}

class ComposeReportsHeaderView: UIView {
    
    private struct Constants {
        static let NibName = "ComposeReportsHeaderView"
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var expandImageView: UIImageView!
    
    weak var delegate: ComposerHeaderViewDelegate?
    var section: Int?
    var rowCount: String {
        get {
            return numberLabel.text ?? ""
        }
        set {
            numberLabel.text = newValue
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
    
    // MARK: -  Lifecycle
    
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
            self.addSubview(view)
        }
    }
    
    @IBAction func closeButtonAction(sender: UIButton) {
        delegate?.didSelectCloseButtonInHeaderView(self)
    }

    @IBAction func expandButtonAction(sender: UIButton) {
        delegate?.didSelectExpandButtonInHeaderView(self)
    }
}
