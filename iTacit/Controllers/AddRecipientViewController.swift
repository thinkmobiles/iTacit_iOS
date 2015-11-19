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
        static let cellIdentifier = "CategoryTableViewCell"
        static let headerViewHeight = CGFloat(49)
		static let numberOfSections = 5
    }
    
    @IBOutlet weak var recipientsCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagSearchControl: TagSearchControl! {
        didSet {
            tagSearchControl.delegate = self
        }
    }

	private var searchTimer: NSTimer?
	private var preDefinedGroups: [NewMessageModel.Recipient] = [.MyDirectReports, .MyIndirectReports, .MyCoWorkers, .MyJobClassification, .MyBusinessUnits]
	private var recipientsCountModel = RecipientsCountModel()

    var hiddenSections = [Int]()

	var businessUnitsList = BusinessUnitListModel()
	var jobClassificationList = JobClassificationListModel()
	var roleList = RoleListModel()
	var permissionGroupList = PermissionGroupsListModel()

	var searchQuery = SearchStringModel(string: "")
	var searchString: String {
		get {
			return searchQuery.string
		}
		set {
			searchQuery.string = newValue
		}
	}

	var recipients = Array<NewMessageModel.Recipient>()

	// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		addKeyboardObservers()
        businessUnitsList.searchQuery = searchQuery
        jobClassificationList.searchQuery = searchQuery
		roleList.searchQuery = searchQuery
        permissionGroupList.searchQuery = searchQuery
		reloadData()
		updateRecipientsCount()
    }

	deinit {
		print("\(self) is Tod")
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

		roleList.load { [weak self] (success) -> Void in
			self?.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Automatic)
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

	private func updateRecipientsCount() {
		recipientsCountModel.load(recipients) { [weak self] (success) -> Void in
			guard let strongSelf = self else {
				return
			}
			strongSelf.recipientsCountLabel.text = String(strongSelf.recipientsCountModel.count)
			strongSelf.tagSearchControl.showClearButton = !(!success && (strongSelf.recipientsCountModel.count == strongSelf.recipients.count))
		}
	}

	// MARK: - Keyboard

	override func keyboardWillShowWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
	}

	override func keyboardWillHideWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
		tableView.contentInset = UIEdgeInsetsZero
	}

}

// MARK: - UITableViewDataSource

extension AddRecipientViewController: UITableViewDataSource {

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return Constants.numberOfSections
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if hiddenSections.contains(section) {
			return 0
		} else {
			switch section {
				case 0: return jobClassificationList.count
				case 1: return businessUnitsList.count
				case 2: return roleList.count
				case 3: return permissionGroupList.count
				case 4: return preDefinedGroups.count
				default: return 0
			}
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier) as! CategoryTableViewCell
		cell.categoryName.font = UIFont.openSansRegular(14.0)
		cell.categoryName.textColor = AppColors.gray

		var recipient: NewMessageModel.Recipient?
		switch indexPath.section {
			case 0:
				cell.categoryName.text = jobClassificationList[indexPath.row].name
				recipient = NewMessageModel.Recipient.JobClassification(jobClassification: jobClassificationList[indexPath.row])
			case 1:
				cell.categoryName.text = businessUnitsList[indexPath.row].name
				recipient = NewMessageModel.Recipient.BusinessUnit(businessUnit: businessUnitsList[indexPath.row])
			case 2:
				cell.categoryName.text = roleList[indexPath.row].name
				recipient = NewMessageModel.Recipient.Role(role: roleList[indexPath.row])
			case 3: cell.categoryName.text = permissionGroupList[indexPath.row].name
				recipient = NewMessageModel.Recipient.PermissionGroup(permissionGroup: permissionGroupList[indexPath.row])
			case 4:
				cell.categoryName.text = preDefinedGroups[indexPath.row].description
				recipient = preDefinedGroups[indexPath.row]
			default: break
		}

		if let recipient = recipient where recipients.contains(recipient) {
			cell.selected = true
			tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
		}

		return cell
	}

}

// MARK: - UITableViewDelegate

extension AddRecipientViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == (Constants.numberOfSections - 1) ? 0 : Constants.headerViewHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.headerViewHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == Constants.numberOfSections - 1 {
			return UIView(frame: CGRectZero)
		}
		
        let header = AddRecipientHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.frame), height: Constants.headerViewHeight))
        header.delegate = self
        header.section = section
		header.isExpanded = !hiddenSections.contains(section)

        switch section {
			case 0:
				header.titleLabel.text = LocalizedString("Job Classification:")
				header.rowCount = String(jobClassificationList.count)
			case 1:
				header.titleLabel.text = LocalizedString("Business Unit:")
				header.rowCount = String(businessUnitsList.count)
			case 2:
				header.titleLabel.text = LocalizedString("Role:")
				header.rowCount = String(roleList.count)
			default:
				header.titleLabel.text = LocalizedString("Group:")
				header.rowCount = String(permissionGroupList.count)
        }
        
        return header
    }

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		switch indexPath.section {
			case 0: recipients.append(NewMessageModel.Recipient.JobClassification(jobClassification: jobClassificationList[indexPath.row]))
			case 1: recipients.append(NewMessageModel.Recipient.BusinessUnit(businessUnit: businessUnitsList[indexPath.row]))
			case 2: recipients.append(NewMessageModel.Recipient.Role(role: roleList[indexPath.row]))
			case 3: recipients.append(NewMessageModel.Recipient.PermissionGroup(permissionGroup: permissionGroupList[indexPath.row]))
			case 4: recipients.append(preDefinedGroups[indexPath.row])
			default: break
		}
		updateRecipientsCount()
	}

	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		var recipient: NewMessageModel.Recipient?
		switch indexPath.section {
			case 0: recipient = NewMessageModel.Recipient.JobClassification(jobClassification: jobClassificationList[indexPath.row])
			case 1: recipient = NewMessageModel.Recipient.BusinessUnit(businessUnit: businessUnitsList[indexPath.row])
			case 2: recipient = NewMessageModel.Recipient.Role(role: roleList[indexPath.row])
			case 3: recipient = NewMessageModel.Recipient.PermissionGroup(permissionGroup: permissionGroupList[indexPath.row])
			case 4: recipient = preDefinedGroups[indexPath.row]
			default: break
		}
		if let recipient = recipient, index = recipients.indexOf(recipient) {
			recipients.removeAtIndex(index)
		}
		updateRecipientsCount()
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
    
    func didSelectCloseButtonInHeaderView(view: UIView) { }
	
}

// MARK: - TagSearchControlDelegate

extension AddRecipientViewController: TagSearchControlDelegate {
    
    func tagsSearchControlSearchButtonPressed(tagsSearchControl: TagSearchControl) {
        searchTimer?.invalidate()
        reloadData()
    }
    
    func tagsSearchControlDidClear(tagsSearchControl: TagSearchControl) {
		searchString = ""
		recipients = recipients.filter { (element) -> Bool in
			if case .Employee(_) = element {
				return true
			} else {
				return false
			}
		}
        reloadData()
    }

	func tagsSearchControlShouldBecameActive(tagsSearchControl: TagSearchControl) -> Bool {
		return true
	}
    
}
