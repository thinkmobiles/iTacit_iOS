//
//  ComposerRecepientsViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/4/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ComposerRecepientsViewController: BaseViewController {
    
    private struct Constants {
        static let headerViewHeight = CGFloat(50)
        static let cellHeight = CGFloat(50)
		static let userProfileICellImageOffsetDefault = CGFloat(14)
		static let userProfileICellImageOffsetShifted = CGFloat(33)
    }
    
    @IBOutlet weak var tableView: UITableView!

    var hiddenSections = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.registerNib(UserProfileTableViewCell.nib, forCellReuseIdentifier: UserProfileTableViewCell.reuseIdentifier)
		tableView.tableFooterView = UIView()
    }
    
    // MARK: - Private
    
    private func showOrHideCellsIn(section section: Int) {
        if hiddenSections.contains(section) {
            hiddenSections.removeAtIndex(hiddenSections.indexOf(section)!)
        } else {
            hiddenSections.append(section)
        }
        
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic);
    }
}

// MARK: - UITableViewDelegate

extension ComposerRecepientsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return  section == 0 ? 0: Constants.headerViewHeight
    }
}

// MARK: - UITableViewDataSource

extension ComposerRecepientsViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hiddenSections.contains(section) {
            return 0
        }
        
        switch section {
			case 0: return 3
			case 1: return 3
			case 2: return 3
			default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(UserProfileTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! UserProfileTableViewCell
        if indexPath.section == 0 {
			cell.style = .Deletable
			cell.separatorHidden = false
			cell.imageOffset = Constants.userProfileICellImageOffsetDefault
			cell.delegate = self
        } else {
			cell.imageOffset = Constants.userProfileICellImageOffsetDefault
			cell.style = .Default
			cell.separatorInset = UIEdgeInsets(top: 0, left: CGRectGetWidth(tableView.frame), bottom: 0, right: 0)
			cell.imageOffset = Constants.userProfileICellImageOffsetShifted
			cell.delegate = nil
        }

		return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRectZero)
        }
        
        let header = ComposeReportsHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetMaxX(UIScreen.mainScreen().bounds), height: Constants.headerViewHeight))
        header.separatorHidden = section == 1
        header.delegate = self
        header.section = section
        header.rowCount = "3"
        
        if hiddenSections.contains(section) {
            header.isExpanded = false
        } else {
            header.isExpanded = true
        }
        
        if section == 1 {

            header.titleLabel.text = LocalizedString("MY DIRECT REPORTS")
        } else {
            header.titleLabel.text =  LocalizedString("MY DIRECT AND INDIRECT REPORTS")
        }
        
        return header
    }
}

// MARK: - UserProfileTableViewCellDelegate

extension ComposerRecepientsViewController: UserProfileTableViewCellDelegate {

	func userProfileTableViewCellDidPressDeleteButton(cell: UserProfileTableViewCell) {
		print("Did delete: \(tableView.indexPathForCell(cell)?.row)")
	}

}

// MARK: - ComposerHeaderViewDelegate

extension ComposerRecepientsViewController: ComposerHeaderViewDelegate {

    func didSelectCloseButtonInHeaderView(view: UIView) {
        //TODO: handle close button
        if view is ComposeReportsHeaderView {
            print("header")
        } else {
            print("cell")
        }
    }

	// TODO: Refactore: replace UIView with ComposerHeaderView otherwithe why it is called "ComposerHeaderViewDelegate"
    func didSelectExpandButtonInHeaderView(view: UIView) {
        if view is ComposeReportsHeaderView {
            if let section = (view as! ComposeReportsHeaderView).section {
                showOrHideCellsIn(section: section)
            }
        }
    }
}
