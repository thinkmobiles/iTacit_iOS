//
//  NewsTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsCategoryLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    var newsImage: UIImage? {
        get {
            return newsImageView.image
        }
        set {
            newsImageView.image = newValue
        }
    }
    
    var titleLabel: String? {
        get {
            return newsTitleLabel.text
        }
        set {
            newsTitleLabel.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
