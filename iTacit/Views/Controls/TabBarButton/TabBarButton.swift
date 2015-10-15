//
//  TabBarButton.swift
//  TabBarController
//
//  Created by Sauron Black on 10/13/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import UIKit

class TabBarButton: UIControl {

	private struct Constants {
		static let NibName = "TabBarButton"
	}

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var badgeLabel: UILabel!

	@IBInspectable var image: UIImage? {
		get {
			return imageView.image
		}
		set {
			imageView.image = newValue
		}
	}

	@IBInspectable var title: String? {
		get {
			return titleLabel.text
		}
		set {
			titleLabel.text = newValue
		}
	}

	var normalTintColor = AppColors.lightGray
	var selectedTintColor = AppColors.blue

	var badgeValue = 0 {
		didSet {
			badgeLabel.hidden = badgeValue == 0
			badgeLabel.text = String(badgeValue)
		}
	}

	override var selected: Bool {
		didSet {
			imageView.tintColor = selected ? selectedTintColor: normalTintColor
			titleLabel.textColor = selected ? selectedTintColor: normalTintColor
		}
	}

	// MARK: - Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)
		loadSubviewFromNIB()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		loadSubviewFromNIB()
	}

	// MARK: - Private 

	func loadSubviewFromNIB() {
		if let view = NSBundle.mainBundle().loadNibNamed(Constants.NibName, owner: self, options: nil).first as? UIView {
			addEdgePinnedSubview(view)
		}
	}
}
