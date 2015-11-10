//
//  FilterNewsViewController.swift
//  iTacit
//
//  Created by Sergey Sheba on 10/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class FilterNewsViewController: BaseViewController {
    
    private struct Constants {
        static let listHeaderViewHeight: CGFloat = 39
        static let dateHeaderViewHeight: CGFloat = 93
		static let authorIdKey = "authorId"
		static let categoryIdKey = "categoryId"
		static let returnToNewsListSegue = "returnToNewsList"
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var tagTextField: TagTextField! {
		didSet {
			tagTextField.delegate = self
		}
	}

	private var searchTimer: NSTimer?
	private let authorList = AuthorListModel()
	private let categoryList = CategoriesListModel()

	var hiddenSections = [2]
	var selectedDateButtonTag: Int = 0

	var searchModel = SearchNewsQueryModel(string: "")
	var searchString = ""
	var tags = [TagModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
		addKeyboardObservers()
		title = LocalizedString("Filter")
		searchButton.setTitle(LocalizedString("SEARCH"), forState: .Normal)
		authorList.searchQuery = SearchAuthorQueryModel(string: searchString)
		categoryList.searchQuery = SearchCategoryQueryModel(string: searchString)
		tagTextField.edgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 0)
		tagTextField.tags = tags
		if searchString.characters.count >= 3 {
			reloadData()
		}
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		tagTextField.beginEditing()
		tagTextField.text = searchString
	}

	deinit {
		removeKeyboardObservers()
	}

	// MARK: - IBActions

	@IBAction func didChangeText(sender: TagTextField) {
		(authorList.searchQuery as? SearchAuthorQueryModel)?.string = sender.text
		(categoryList.searchQuery as? SearchCategoryQueryModel)?.string = sender.text
		searchTimer?.invalidate()
		if sender.text.characters.count >= 3 {
			searchTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("performSearch:"), userInfo: nil, repeats: false)
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let identifier = segue.identifier where identifier == Constants.returnToNewsListSegue {
			tags = tagTextField.tags
		}
	}
	
    // MARK: - Private

	func performSearch(sender: NSTimer) {
		reloadData()
	}

	private func reloadData() {
		authorList.load { [weak self] (success) -> Void in
			guard let strongSelf = self else {
				return
			}
			if !strongSelf.hiddenSections.contains(0) {
				strongSelf.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
			}
		}

		categoryList.load { [weak self] (success) -> Void in
			guard let strongSelf = self else {
				return
			}
			if !strongSelf.hiddenSections.contains(1) {
				strongSelf.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
			}
		}
	}

    private func showOrHideCellsIn(section section: Int) {
        if hiddenSections.contains(section) {
            hiddenSections.removeAtIndex(hiddenSections.indexOf(section)!)
            if section == 2 {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock { [weak self] () -> Void in
                    let indexPath = NSIndexPath(forRow:0, inSection: section)
                    self?.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                }
                
                tableView.beginUpdates()
                tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .None)
                tableView.endUpdates()
                
                CATransaction.commit()
            }
        } else {
            hiddenSections.append(section)
        }

        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic);
    }

	private func authorTagForId(authorId: String) -> TagModel? {
		let index = tagTextField.tags.indexOf { ($0.attributes?[Constants.authorIdKey] ?? "") == authorId }
		if let index = index {
			return tagTextField.tags[index]
		} else {
			return nil
		}
	}

	private func categoryTagForId(categoryId: String) -> TagModel? {
		let index = tagTextField.tags.indexOf { ($0.attributes?[Constants.categoryIdKey] ?? "") == categoryId }
		if let index = index {
			return tagTextField.tags[index]
		} else {
			return nil
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

extension FilterNewsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hiddenSections.contains(section) {
            return 0
        }

		switch section {
			case 0: return authorList.count
			case 1: return categoryList.count
			default: return 1
		}
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell") as! UserTableViewCell
			let author = authorList[indexPath.item]
			cell.fullName = author.fullName
			cell.userAttributesText = author.roleName

			if let imageURL = author.imageURL {
				ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { (image) -> Void in
					cell.userImage = image
				})
			} else {
				cell.userImage = nil
			}

			let contains = tagTextField.tags.contains { ($0.attributes?[Constants.authorIdKey] ?? "") == author.id }

			cell.selectable = true
			cell.selected = contains
			if contains {
				tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
			}

            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell") as! CategoryTableViewCell
			let category = categoryList[indexPath.item]
            cell.categoryName.text = category.categoryName

			let contains = tagTextField.tags.contains { ($0.attributes?[Constants.categoryIdKey] ?? "") == category.categoryId }

			cell.selected = contains
			if contains {
				tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
			}
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DatePickerTableViewCell") as! DatePickerTableViewCell
            cell.delegate = self
            if selectedDateButtonTag == 1 {
                cell.setDatePickerLimits(nil, maximumDate: searchModel.endDate, selectedDate: searchModel.startDate)
            } else {
                cell.setDatePickerLimits(searchModel.startDate, maximumDate: nil, selectedDate: searchModel.endDate)
            }
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
		switch indexPath.section {
			case 0:
				let author = authorList[indexPath.item]
				searchModel.authorIDs.append(author.id)
				tagTextField.insertTag(author.fullName, attributes: [Constants.authorIdKey: author.id])
			case 1:
				let category = categoryList[indexPath.item]
				searchModel.categoryIDs.append(category.categoryId)
				tagTextField.insertTag(category.categoryName, attributes: [Constants.categoryIdKey: category.categoryId])
			default: break
		}
    }

	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		switch indexPath.section {
			case 0:
				let author = authorList[indexPath.item]
				if let index = searchModel.authorIDs.indexOf(author.id) {
					searchModel.authorIDs.removeAtIndex(index)
				}

				if let tag = authorTagForId(author.id) {
					tagTextField.removeTag(tag)
				}

			case 1:
				let category = categoryList[indexPath.item]
				if let index = searchModel.categoryIDs.indexOf(category.categoryId) {
					searchModel.categoryIDs.removeAtIndex(index)
				}
				if let tag = categoryTagForId(category.categoryId) {
					tagTextField.removeTag(tag)
				}
			default: break
		}
	}

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < 2 {
            let header = ListHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetMaxX(self.view.frame), height: Constants.listHeaderViewHeight))
            header.section = section
            header.delegate = self
			header.rowCount = "\(section == 0 ? authorList.count: categoryList.count)"

            if hiddenSections.contains(section) {
                header.isExpanded = false
            } else {
                header.isExpanded = true
            }
            
            return header
        } else {
            let header = DateHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetMaxX(self.view.frame), height: Constants.dateHeaderViewHeight))
            header.section = section
            header.delegate = self
            header.searchNewsModel = searchModel
            
            return header
        }
    }
    
}

// MARK: - ListHeaderViewDelegate

extension FilterNewsViewController: ListHeaderViewDelegate {
	
    func didSelectHeaderWithSection(headerView: UIView) {
        if headerView is ListHeaderView {
            if let section = (headerView as! ListHeaderView).section {
                showOrHideCellsIn(section: section)
            }
        }
        if headerView is DateHeaderView {
            if let section = (headerView as! DateHeaderView).section {
                showOrHideCellsIn(section: section)
            }
        }
    }
    
    func didSelectHeaderWithSection(headerView: UIView, button: UIButton) {
        selectedDateButtonTag = button.tag
        didSelectHeaderWithSection(headerView)
    }
}

// MARK: - DatePickerCellDelegate

extension FilterNewsViewController: DatePickerCellDelegate {
    
    func didPressDoneButtonWithDate(date: NSDate) {

        if selectedDateButtonTag == 1 {
            searchModel.startDate = date
            didPressCancelButton()
        } else {
            searchModel.endDate = date
            didPressCancelButton()
        }
    }
    
    func didPressCancelButton() {
        showOrHideCellsIn(section: 2)
    }
}

// MARK: - TagSearchControlDelegate

extension FilterNewsViewController: TagTextFieldDelegate {

	func tagedTextFieldShouldBeginEditing(textField: TagTextField) -> Bool {
		return true
	}

	func tagedTextFieldDidReturn(textField: TagTextField) {}

	func tagedTextFieldDidBeginEditing(textField: TagTextField) {}

	func tagedTextFieldDidEndEditing(textField: TagTextField) {}

	func tagedTextFieldShouldInserTag(textField: TagTextField, tag: String) -> Bool {
		return false
	}

	func tagedTextFieldShouldSwitchToCollapsedMode(textField: TagTextField) -> Bool {
		return false
	}

	func tagedTextField(textField: TagTextField, didDeleteTag tag: TagModel) {
		if let authorId = tag.attributes?[Constants.authorIdKey] where !hiddenSections.contains(0) {
			let index = authorList.objects.indexOf { $0.id == authorId }
			if let index = index {
				tableView.deselectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false)
			}
		} else if let categoryId = tag.attributes?[Constants.categoryIdKey] where !hiddenSections.contains(1) {
			let index = categoryList.objects.indexOf { $0.categoryId == categoryId }
			if let index = index {
				tableView.deselectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1), animated: false)
			}

		}
	}

	func tagedTextField(textField: TagTextField, didChangeContentSize contentSize: CGSize) {}

}
