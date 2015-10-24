//
//  TextCollectionViewCell.swift
//  TagsSearchControl
//
//  Created by Sauron Black on 10/16/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {

	static let reuseIdentifier = "TextCollectionViewCell"
	
	@IBOutlet weak var textLabel: UILabel!

	override var selected: Bool {
		didSet {
			backgroundColor = selected ? AppColors.lightGray : AppColors.dirtyWhite
			textLabel.textColor = selected ? AppColors.dirtyWhite : AppColors.lightGray
		}
	}

	var text: String {
		get {
			return textLabel.text ?? ""
		}
		set {
			textLabel.text = newValue
		}
	}

}
