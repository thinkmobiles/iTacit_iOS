//
//  BannerViewController.swift
//  iTacit
//
//  Created by Sauron Black on 11/26/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class BannerViewController: UIViewController {

	static let storyboardId = "BannerViewController"

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var detailsLabel: UILabel!

	var pageIndex = 0
	var banner: BannerModel?

	var imageDownloadTask: NSURLSessionTask? {
		didSet {
			if let _ = imageDownloadTask {
				imageView.image = nil
			}
		}
	}

	// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

		if let banner = banner {
			configureWithBanner(banner)
		}
    }

	// MARK: - Private

	private func configureWithBanner(banner: BannerModel) {
		setImageWithURL(banner.imageURL)
		titleLabel.text = banner.title.uppercaseString
		detailsLabel.text = banner.details?.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}

	private func setImageWithURL(imageURL: NSURL?) {
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
