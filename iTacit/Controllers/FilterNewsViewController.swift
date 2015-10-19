//
//  FilterNewsViewController.swift
//  iTacit
//
//  Created by Sergey Sheba on 10/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class FilterNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section < 2 ? 3 : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell") as! UserTableViewCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell") as! CategoryTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DatePickerTableViewCell") as! DatePickerTableViewCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section < 2 ? 47 : 183
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < 2 {
            let header = tableView.dequeueReusableCellWithIdentifier("ListHeaderCellTableViewCell") as! ListHeaderCellTableViewCell
            return header
        } else {
            let header = tableView.dequeueReusableCellWithIdentifier("DateHeaderTableViewCell") as! DateHeaderTableViewCell
            return header
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section < 2 ? 39 : 93
    }
}