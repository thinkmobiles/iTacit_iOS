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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
    }

    var someText: String {
        return "// MARK: - Navigation\n// In a storyboard-based application, you will often want to do a little preparation before navigation\noverride func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {\n// Get the new view controller using segue.destinationViewController.\n// Pass the selected object to the new view controller."
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
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TitleTableViewCell", forIndexPath: indexPath) as! TitleTableViewCell
            cell.titleLabel.text = someText
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionTableViewCell", forIndexPath: indexPath) as! DescriptionTableViewCell
            cell.descriptionLabel.text = someText
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("HashtagAndTimeTableViewCell", forIndexPath: indexPath) as! HashtagAndTimeTableViewCell
            
            cell.hashtagLabel.text = someText
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell", forIndexPath: indexPath) as! UserTableViewCell
            //        cell.selectable = false
            
            return cell
        }
    }
}

