//
//  HashtagAndTimeTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/16/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class HashtagAndTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
