//
//  LogoTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/26/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

enum CellType {
    case CellTypeDefault
    case CellTypeWithoutLabel
}

class LogoTableViewCell: UITableViewCell {
    
    var cellType: CellType = .CellTypeDefault {
        didSet {
            customerNameLabel.text = LocalizedString("Customer Name")

            switch cellType {
                case .CellTypeDefault:
                    customerNameLabel.hidden = false
                case .CellTypeWithoutLabel:
                    customerNameLabel.hidden = true
            }
        }
    }

    @IBOutlet weak var customerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
