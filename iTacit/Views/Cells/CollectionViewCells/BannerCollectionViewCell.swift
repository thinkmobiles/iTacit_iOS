//
//  BannerCollectionViewCell.swift
//  iTacit
//
//  Created by Sauron Black on 11/26/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

	static let reuseIdentifier = "BannerCollectionViewCell"

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var detailsLabel: UILabel!
	
	var imageDownloadTask: NSURLSessionTask? {
		didSet {
			if let _ = imageDownloadTask {
				imageView.image = nil
			}
		}
	}

	func configureWithBanner(banner: BannerModel) {
		setImageWithURL(banner.imageURL)
		titleLabel.text = banner.title.uppercaseString
		detailsLabel.text = banner.details?.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//		if let details = banner.details {
//			detailsLabel.text = details.string
//			let detailsString = NSMutableAttributedString(string: details.string)
//			detailsString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, (details.string as NSString).length))
//			detailsLabel.attributedText = detailsString
//		} else {
//			detailsLabel.attributedText = nil
//		}
	}

	func setImageWithURL(imageURL: NSURL?) {
		if let imageURL = imageURL {
			imageDownloadTask?.cancel()
			imageDownloadTask = ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { [weak self] (image) -> Void in
				self?.imageView.image = image
			})
		} else {
			imageView.image = nil
		}
	}

}
