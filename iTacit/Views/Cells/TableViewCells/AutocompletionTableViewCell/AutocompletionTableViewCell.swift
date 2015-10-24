//
//  AutocompletionTableViewCell.swift
//  TagsSearchControl
//
//  Created by Sauron Black on 10/21/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import UIKit

class AutocompletionTableViewCell: UITableViewCell {

	static let reuseIdentifier = "AutocompletionTableViewCell"

	@IBOutlet weak var titleLabel: UILabel!

	var title: String {
		get {
			return titleLabel.text ?? ""
		}
		set {
			titleLabel.text = newValue
		}
	}
    
}
