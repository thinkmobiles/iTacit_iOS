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
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var tagTextField: TagTextField!

	private var searchTimer: NSTimer?

	var showFirstSection = true;
	var indexPathesArray = [2]
	var selectedDateButtonTag: Int!

	var searchModel = SearchNewsQueryModel(string: "")
	var searchString = ""

	private let  authorList = AuthorListModel()
    private let categoriesList = CategoriesListModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		addKeyboardObservers()
		searchButton.setTitle(LocalizationService.LocalizedString("SEARCH"), forState: .Normal)
		searchModel.string = searchString
		authorList.searchQuery = SearchAuthorQueryModel(string: searchString)
		categoriesList.searchQuery = SearchCategoryQueryModel(string: searchString)
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
		(categoriesList.searchQuery as? SearchCategoryQueryModel)?.string = sender.text
		searchTimer?.invalidate()
		if sender.text.characters.count >= 3 {
			searchTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("performSearch:"), userInfo: nil, repeats: false)
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
			if !strongSelf.indexPathesArray.contains(0) {
				strongSelf.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
			}
		}

		categoriesList.load { [weak self] (success) -> Void in
			guard let strongSelf = self else {
				return
			}
			if !strongSelf.indexPathesArray.contains(1) {
				strongSelf.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
			}
		}
	}

    private func showOrHideCellsIn(section section: Int) {
        if indexPathesArray.contains(section) {
            indexPathesArray.removeAtIndex(indexPathesArray.indexOf(section)!)
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
            indexPathesArray.append(section)
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

// MARK: - UITableViewDataSource

extension FilterNewsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if indexPathesArray.contains(section) {
            return 0
        }

		switch section {
			case 0: return authorList.count
			case 1: return categoriesList.count
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
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell") as! CategoryTableViewCell
            cell.categoryName.text = categoriesList[indexPath.item].categoryName
            
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
			header.rowCount = "\(section == 0 ? authorList.count: categoriesList.count)"

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
        didSelectHeaderWithSection(headerView)
        selectedDateButtonTag = button.tag
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
