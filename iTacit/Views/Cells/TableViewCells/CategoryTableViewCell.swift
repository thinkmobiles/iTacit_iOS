//
//  CategoryTableViewCell.swift
//  iTacit
//
//  Created by Sergey Sheba on 10/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    var hiddenSeparator: Bool {
        get {
            return separatorView.hidden
        }
        set {
            separatorView.hidden = newValue
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectCategoryButton.selected = selected
    }

}
