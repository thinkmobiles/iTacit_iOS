//
//  RememberMeTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/26/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class RememberMeTableViewCell: UITableViewCell {

    @IBOutlet weak var rememberMeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rememberMeButton .setImage(UIImage(assetsIndetifier: .UnconfirmedIcon), forState: .Normal)
        rememberMeButton .setImage(UIImage(assetsIndetifier: .SelectedIcon), forState: .Selected)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func rememberMeAction(sender: UIButton) {
        rememberMeButton.selected = !rememberMeButton.selected
    }

}
