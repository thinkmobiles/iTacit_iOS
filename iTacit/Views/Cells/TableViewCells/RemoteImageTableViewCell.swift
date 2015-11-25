//
//  RemoteImageTableViewCell.swift
//  iTacit
//
//  Created by Sauron Black on 11/24/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class RemoteImageTableViewCell: UITableViewCell {

	@IBOutlet weak var pictureImageView: UIImageView!

	var imageDownloadTask: NSURLSessionTask? {
		didSet {
			if let _ = imageDownloadTask {
				pictureImageView = nil
			}
		}
	}

	func setImageWithURL(imageURL: NSURL?) {
		if let imageURL = imageURL {
			imageDownloadTask?.cancel()
			pictureImageView.image = nil
			imageDownloadTask = ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { [weak self] (image) -> Void in
				self?.pictureImageView.image = image
			})
		} else {
			pictureImageView.image = nil
		}
	}

}
