//
//  ListHeaderView.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/21/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ListHeaderViewDelegate {
    func didSelectHeaderWithSection(headerView: UIView)
    func didSelectHeaderWithSection(headerView: UIView, button: UIButton)

}

class ListHeaderView: UIView {

	private struct Constants {
		static let NibName = "ListHeaderView"
	}

    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var numberOfCellsLabel: UILabel!
    @IBOutlet weak var disclosureImageView: UIImageView!
    
    var delegate: ListHeaderViewDelegate?
    
    var section: Int? {
        didSet {
            headerTitleLabel.text = LocalizationService.LocalizedString(section == 0 ? "Author" : "Category") + ": "
        }
    }

	var rowCount: String {
		get {
			return numberOfCellsLabel.text ?? ""
		}
		set {
			numberOfCellsLabel.text = newValue
		}
	}
    
    var isExpanded = false {
        didSet {
            if isExpanded {
                disclosureImageView.image = UIImage(assetsIndetifier: .TrianglePointerDown)
            } else  {
                disclosureImageView.image = UIImage(assetsIndetifier: .TrianglePointerUp)
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

	// MARK: - IBActions

    @IBAction func expandButtonAction(sender: UIButton) {
        delegate?.didSelectHeaderWithSection(self)
    }
    
    // MARK: - Private
    
    func loadViewFromNib() {
        if let view = NSBundle.mainBundle().loadNibNamed(Constants.NibName, owner: self, options: nil).first as? UIView {
            self.addSubview(view)
        }
    }
}
