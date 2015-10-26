//
//  FilterNewsViewController.swift
//  iTacit
//
//  Created by Sergey Sheba on 10/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class FilterNewsViewController: UIViewController {
    
    private struct Constants {
        static let listHeaderViewHeight: CGFloat = 39
        static let dateHeaderViewHeight: CGFloat = 93
    }
    
    var showFirstSection: Bool = true;
    var indexPathesArray: [Int] = [2]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private
    
    func manageCellsInSections(section: Int) {
        if indexPathesArray.contains(section) {
            indexPathesArray.removeAtIndex(indexPathesArray.indexOf(section)!)
        } else {
            indexPathesArray.append(section)
        }

        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic);
    }
}

// MARK: - UITableViewDataSource

extension FilterNewsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if indexPathesArray.contains(section) {
            return 0
        }
        
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
            cell.delegate = self
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension FilterNewsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section < 2 ? Constants.listHeaderViewHeight : Constants.dateHeaderViewHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section < 2 ? 47 : 183
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            showFirstSection = !showFirstSection
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < 2 {
            let header = ListHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetMaxX(self.view.frame), height: Constants.listHeaderViewHeight))
            header.section = section
            header.delegate = self
            
            if indexPathesArray.contains(section) {
                header.isExpanded = false
            } else {
                header.isExpanded = true
            }
            
            return header
        } else {
            let header = DateHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetMaxX(self.view.frame), height: Constants.dateHeaderViewHeight))
            header.section = section
            header.delegate = self
            
            return header
        }
    }
    
}

// MARK: - ListHeaderViewDelegate

extension FilterNewsViewController: ListHeaderViewDelegate {
    func didSelectHeaderWithSection(headerView: UIView) {
        if headerView is ListHeaderView {
            if let section = (headerView as! ListHeaderView).section {
                manageCellsInSections(section)
            }
        }
        if headerView is DateHeaderView {
            if let section = (headerView as! DateHeaderView).section {
                manageCellsInSections(section)
            }
        }
    }
}

// MARK: - DatePickerCellDelegate

extension FilterNewsViewController: DatePickerCellDelegate {
    func didPressedDoneButton() {
        
    }
    
    func didPressedCancelButton() {
        manageCellsInSections(2)
    }
}
