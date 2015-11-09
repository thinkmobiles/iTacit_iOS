//
//  AddRecipientViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/5/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class AddRecipientViewController: BaseViewController {
    
    private struct Constants {
        static let CellIdentifier = "CategoryTableViewCell"
        static let HeaderViewHeight: CGFloat = 49
    }
    
    @IBOutlet weak var recipientsCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var hiddenSections: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    
    @IBAction func bottomButtonAction(sender: UIButton) {
    }
    
    // MARK: - Private
    
    private func showOrHideCellsIn(section section: Int) {
        
        if hiddenSections.contains(section) {
            hiddenSections.removeAtIndex(hiddenSections.indexOf(section)!)
            tableView.beginUpdates()
            tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .None)
            tableView.endUpdates()
        } else {
            hiddenSections.append(section)
        }
        
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic);
    }
}

extension AddRecipientViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.HeaderViewHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = AddRecipientHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.frame), height: Constants.HeaderViewHeight))

        header.delegate = self
        header.section = section
        header.rowCount = section < 2 ? "3" : "0"
        
        if hiddenSections.contains(section) {
            header.isExpanded = false
        } else {
            header.isExpanded = true
        }
        
        switch section {
        case 0: header.titleLabel.text = LocalizedString("Job Classification:")
        case 1: header.titleLabel.text = LocalizedString("Business Unit:")
        case 2: header.titleLabel.text = LocalizedString("Role:")
        default: header.titleLabel.text = LocalizedString("Group:")
        }
        
        return header
    }
}

extension AddRecipientViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCellWithIdentifier(Constants.CellIdentifier) as! CategoryTableViewCell
        
        if indexPath.row == 2 {
            cell.hiddenSeparator = true
        } else {
            cell.hiddenSeparator = false
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hiddenSections.contains(section) {
            return 0
        }
        
        return section < 2 ? 3 : 0
    }
}

extension AddRecipientViewController: ComposerHeaderViewDelegate {
    func didSelectExpandButtonInHeaderView(view: UIView) {
        
        if view is AddRecipientHeaderView {
            if let section = (view as! AddRecipientHeaderView).section {
                showOrHideCellsIn(section: section)
            }
        }
    }
    
    func didSelectCloseButtonInHeaderView(view: UIView) {
        
    }
}
