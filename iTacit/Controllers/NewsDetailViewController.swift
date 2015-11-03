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
    var userModel: UserProfileModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0)

		userModel = UserProfileModel()
		userModel?.userId = newsModel?.authorId ?? ""

		newsModel?.load({ [weak self] (success) -> Void in
            self?.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: .Automatic)
		})

        userModel?.load({ [weak self] (success) -> Void in
            self?.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 4, inSection: 0)], withRowAnimation: .Automatic)
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
				ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { (image) -> Void in
					cell.mewsImageView.image = image
				})
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
            
            if let imageURL = userModel?.imageUrl {
                ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { (image) -> Void in
                    cell.userAvatarImageView.image = image
                })
            }
            
            if let nameFirst = userModel?.nameFirst, nameLast = userModel?.nameLast {
                cell.userNameLabel.text = nameFirst + " " + nameLast
            }
            
            let nameFirst: String? = userModel?.nameFirst
            let nameLast: String? = userModel?.nameLast

            switch (nameFirst, nameLast) {
            case let (nameFirst?, nameLast?):
                cell.userNameLabel.text = nameFirst + " " + nameLast
            case let (nameFirst?, nil):
                cell.userNameLabel.text = nameFirst
            case let (nil, nameLast?):
                cell.userNameLabel.text = nameLast
            case (nil, nil):
                cell.userNameLabel.text = ""
            }
            
            let roleName: String? = userModel?.roleName
            let businessUnitName: String? = userModel?.businessUnitName
            
            switch (roleName, businessUnitName) {
            case let (roleName?, businessUnitName?):
                cell.userDescriptionLabel.text = roleName + " / " + businessUnitName
            case let (roleName?, nil):
                cell.userDescriptionLabel.text = roleName
            case let (nil, businessUnitName?):
                cell.userDescriptionLabel.text = businessUnitName
            case (nil, nil):
                cell.userDescriptionLabel.text = ""
            }
            
            return cell
        }
    }
}

