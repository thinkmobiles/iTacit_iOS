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
    
    var title: String? {
        get {
            return newsTitleLabel.text
        }
        set {
            newsTitleLabel.text = newValue
        }
    }

	var imageDownloadTask: NSURLSessionTask? {
		didSet {
			if let _ = imageDownloadTask {
				newsImage = nil
			}
		}
	}

}
