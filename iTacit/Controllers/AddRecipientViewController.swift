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
    @IBOutlet weak var tagSearchControl: TagSearchControl! {
        didSet {
            tagSearchControl.delegate = self
        }
    }
    
    var hiddenSections = [Int]()
	var searchQuery = SearchStringModel(string: "")
	var searchString: String {
		get {
			return searchQuery.string
		}
		set {
			searchQuery.string = newValue
		}
	}
    var businessUnitsList = BusinessUnitListModel()
    var jobClassificationList = JobClassificationListModel()
    var permissionGroupList = PermissionGroupsListModel()

    private var searchTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		addKeyboardObservers()
        businessUnitsList.searchQuery = searchQuery
        jobClassificationList.searchQuery = searchQuery
        permissionGroupList.searchQuery = searchQuery
		tagSearchControl.searchText = searchString
        reloadData()
    }

	deinit {
		removeKeyboardObservers()
	}
    
    // MARK: - IBAction

    @IBAction func didChangeText(sender: TagSearchControl) {
		searchString = sender.searchText
		searchTimer?.invalidate()
		searchTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("performSearch:"), userInfo: nil, repeats: false)
    }
    
    @IBAction func bottomButtonAction(sender: UIButton) {
        
    }
    
    // MARK: - Private
    
    func performSearch(sender: NSTimer) {
        reloadData()
    }
    
	private func reloadData() {
		jobClassificationList.load { [weak self] (success) -> Void in
			self?.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
		}

        businessUnitsList.load { [weak self] (success) -> Void in
            self?.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
        }
        
        permissionGroupList.load { [weak self] (success) -> Void in
			self?.tableView.reloadSections(NSIndexSet(index: 3), withRowAnimation: .Automatic)
        }
    }
    
    private func showOrHideCellsIn(section section: Int) {
        if hiddenSections.contains(section) {
            hiddenSections.removeAtIndex(hiddenSections.indexOf(section)!)
        } else {
            hiddenSections.append(section)
        }
        
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic);
    }

	// MARK: - Keyboard

	override func keyboardWillShowWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
	}

	override func keyboardWillHideWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
		tableView.contentInset = UIEdgeInsetsZero
	}

}

// MARK: - UITableViewDelegate

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
			case 0:
				header.titleLabel.text = LocalizedString("Job Classification:")
				header.rowCount = String(jobClassificationList.count)
			case 1:
				header.titleLabel.text = LocalizedString("Business Unit:")
				header.rowCount = String(businessUnitsList.count)
			case 2:
				header.titleLabel.text = LocalizedString("Role:")
			default:
				header.titleLabel.text = LocalizedString("Group:")
				header.rowCount = String(permissionGroupList.count)
        }
        
        return header
    }

}

// MARK: - UITableViewDataSource

extension AddRecipientViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCellWithIdentifier(Constants.CellIdentifier) as! CategoryTableViewCell
        
        cell.categoryName.font = UIFont.openSansRegular(14.0)
        cell.categoryName.textColor = AppColors.gray
        
        if indexPath.section == 0 {
            cell.categoryName.text = jobClassificationList[indexPath.item].name
        } else if indexPath.section == 1 {
            cell.categoryName.text = businessUnitsList[indexPath.item].name
        } else if indexPath.section == 2 {
            
        }else if indexPath.section == 3 {
            cell.categoryName.text = permissionGroupList[indexPath.item].name
        }
        
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
        
        switch section {
            case 0: return jobClassificationList.count
            case 1: return businessUnitsList.count
            case 2: return 0
            case 3: return permissionGroupList.count
            default: return 0
        }
    }

}

// MARK: - ComposerHeaderViewDelegate

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

// MARK: - TagSearchControlDelegate

extension AddRecipientViewController: TagSearchControlDelegate {
    
    func tagsSearchControlSearchButtonPressed(tagsSearchControl: TagSearchControl) {
        searchTimer?.invalidate()
        reloadData()
    }
    
    func tagsSearchControlDidClear(tagsSearchControl: TagSearchControl) {
		searchString = ""
        reloadData()
    }

	func tagsSearchControlShouldBecameActive(tagsSearchControl: TagSearchControl) -> Bool {
		return true
	}
    
}
