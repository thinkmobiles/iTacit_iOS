//
//  NewsDetailViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/16/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    private struct Constants {
        static let heightOfUserCell: CGFloat = 47
        static let numberOfCells: Int = 5
    }

    @IBOutlet weak var tableView: UITableView!

	var newsModel: NewsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
		newsModel?.load({ [weak self] (success) -> Void in
			self?.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: .Automatic)
		})
    }

	deinit {
		newsModel?.body = nil
	}

}

// MARK: - UITableViewDelegate

extension NewsDetailViewController: UITableViewDelegate {
 
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGRectGetMaxX(UIScreen.mainScreen().bounds) * 360 / 640
        } else if indexPath.row == 4 {
            return Constants.heightOfUserCell
        } else {
            return UITableViewAutomaticDimension
        }
    }

}

// MARK: - UITableViewDelegate

extension NewsDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfCells
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageTableViewCell", forIndexPath: indexPath) as! ImageTableViewCell
			if let imageURL = newsModel?.headlineImageURL {
				if let image = ImageCache.objectForKey(imageURL) as? UIImage {
					cell.mewsImageView.image = image
				} else {
					let request = NSMutableURLRequest(URL: imageURL)
					request.HTTPMethod = URLRequestMethod.GET.rawValue
					let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, _, _) -> Void in
						dispatch_async(dispatch_get_main_queue()) { () -> Void in
							if let data = data, image = UIImage(data: data) {
								ImageCache.setObject(image, forKey: imageURL)
								cell.mewsImageView.image = image
							}
						}
					})
					task.resume()
				}
			}
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TitleTableViewCell", forIndexPath: indexPath) as! TitleTableViewCell
            cell.titleLabel.text = newsModel?.headline
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionTableViewCell", forIndexPath: indexPath) as! DescriptionTableViewCell
            cell.descriptionLabel.attributedText = newsModel?.body
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("HashtagAndTimeTableViewCell", forIndexPath: indexPath) as! HashtagAndTimeTableViewCell
            
            cell.hashtagLabel.text = newsModel?.categoryName
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell", forIndexPath: indexPath) as! UserTableViewCell
            
            return cell
        }
    }
}

