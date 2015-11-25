//
//  MessageDetailViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/12/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessageDetailViewController: BaseViewController {
    
    private struct Constants {
        static let CellHeight: CGFloat = 103
        static let CellId = "MessageDetailCommentTableViewCell"
        static let Iphone_3_5: CGFloat = 480.0
        static let NumberOfRowsFor_3_5: CGFloat = 2
        static let DefaultNumberOfRows: CGFloat = 3
        static let bodyLabelLineHeightMultiple = CGFloat(0.85)
        static let ReplyViewControllerID = "ReplayViewController"
		static let replayToUserSegue = "ReplayToUserSegue"
		static let replyOnReplySegue = "ReplyOnReplySegue"
        static let replyAllSegue = "ReplyAllSegue"
		static let showAllRecipientsSegue = "ShowAllRecipients"
		static let showRecipientsThatHaveReadSegue = "ShowRecipientsThatHaveRead"
		static let confirmationLabelHeight = CGFloat(14)
		static let topLayoutHeight = CGFloat(64.0)
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerConfirmToDate: UILabel!
    @IBOutlet weak var replyToAllButton: UIButton!
    @IBOutlet weak var replyToUserButton: UIButton!
    @IBOutlet weak var showMoreTextView: ShowMoreTextView!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var confirmationLabelHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var repicientsButton: UIButton!
	@IBOutlet weak var confirmedRecipientsButton: UIButton!
    
    var replyToUserName: String {
        get {
            return replyToUserButton.titleLabel?.text ?? ""
        }
        set {
            replyToUserButton.setTitle(" " + LocalizedString("to") + " " + newValue, forState: .Normal)
        }
    }

    static let readToDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM.dd"
        return dateFormatter
    }()

    var message: MessageModel!
    var repliesList = ReplyListModel()
    let searchQuery = SearchReplyListModel()
    var needsToReloadCell = false
	let recipientList = RecipientListModel()

	// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = Constants.CellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = AppColors.dirtyWhite
		recipientList.searchQuery = RecipientSearchQuery(messageId: message.id)
        repliesList.searchQuery = searchQuery
        searchQuery.string = message.id
        showMoreTextView.shouldTrim = true
		showMoreTextView.textContainer.lineFragmentPadding = 0
		showMoreTextView.textContainerInset = UIEdgeInsetsZero
        showMoreTextView.attributedTrimText = NSMutableAttributedString(string: "...")
        scrollView.backgroundColor = AppColors.dirtyWhite

		loadRecipients()
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		loadReplies()
        prepareUI()
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        adjustTableViewHeight()
    }

    // MARK: - IBAction
    
    @IBAction func confirmedReadAction(sender: UIButton) {
        if !showMoreTextView.isExpanded {
            showMoreTextView.maximumNumberOfLines = 0
            showMoreTextView.shouldTrim = false
            return
        }
        message.confirm { [unowned self] (success) -> Void in
            if success {
                self.setConfirmed()
            }
        }
    }
    
    // MARK: - Private
    
    private func adjustTableViewHeight() {
        tableViewHeightConstraint.constant = CGRectGetHeight(view.frame) - CGRectGetHeight(headerView.frame)
    }
    
    private func loadReplies() {
        repliesList.load { [weak self] (success) -> Void in
            self?.tableView.reloadData()
        }
    }

	private func loadMoreReplies() {
		repliesList.loadMore({ [weak self] (success) -> Void in
			self?.tableView.reloadData()
		})
	}

	private func loadRecipients() {
		recipientList.loadMore { [weak self] (success) -> Void in
			guard let strongSelf = self else {
				return
			}

			if !strongSelf.recipientList.loadedAll {
				strongSelf.loadRecipients()
			} else {
				strongSelf.repicientsButton.setTitle("  \(strongSelf.recipientList.count)", forState: .Normal)
				let confirmedRecipients = strongSelf.recipientList.objects.filter( { $0.hasConfirmed } )
				strongSelf.confirmedRecipientsButton.setTitle("  \(confirmedRecipients.count)", forState: .Normal)
			}
		}
	}
    
    private func prepareUI() {
        if let sender = message.sender {
            replyToUserName = sender.firstName
            titleLabel.text = sender.fullName

        }
        
        switch message.readRequirementType {
			case .NotRequired:
				confirmationLabelHeightConstraint.constant = 0
				confirmationButton.hidden = true
			case .RequiredTo(let date):
				confirmationButton.hidden = false
				confirmationLabelHeightConstraint.constant = Constants.confirmationLabelHeight
				confirmationButton.layer.borderWidth = 1.0
				confirmationButton.userInteractionEnabled = true
				confirmationButton.setTitle("  " + LocalizedString("I HAVE READ THIS"), forState: .Normal)
				confirmationButton.setImage(UIImage(assetsIndetifier: .UnconfirmedIcon).imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
				headerConfirmToDate.text = LocalizedString("Please confirm By ") + MessageDetailViewController.readToDateFormatter.stringFromDate(date)
				confirmationButton.setTitleColor(AppColors.blue, forState: .Normal)
        }
        
        if let body = message.body {
            let trimmedBody = body.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            showMoreTextView.attributedText = NSAttributedString(string: trimmedBody)
        }
        
        timeAgoLabel.text = message.sendDate?.timeAgoStringRepresentation()
        headerTitle.text = message.subject
        replyToAllButton.setTitle(" " + LocalizedString("All"), forState: .Normal)
    }
    
    private func setConfirmed() {
		confirmationLabelHeightConstraint.constant = 0
		confirmationButton.layer.borderWidth = 0.5
		confirmationButton.userInteractionEnabled = false
		let titleText = "  " + LocalizedString("Confirmed read on ") + MessageDetailViewController.readToDateFormatter.stringFromDate(NSDate())
		confirmationButton.setTitle(titleText, forState: .Normal)
		confirmationButton.setImage(UIImage(assetsIndetifier: .ConfirmedIcon), forState: .Normal)
		confirmationButton.setTitleColor(AppColors.gray, forState: .Normal)
		headerConfirmToDate.text = ""
        adjustTableViewHeight() 
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier else {
			return
		}
		if let recipientsViewController = segue.destinationViewController as? RecipientsViewController {
			switch identifier {
				case Constants.showAllRecipientsSegue:
					recipientsViewController.recipientList = recipientList
				case Constants.showRecipientsThatHaveReadSegue:
					let recipientsThatHaveRead = RecipientListModel(path: recipientList.recipientListPath)
					recipientsThatHaveRead.objects = recipientList.objects.filter { $0.hasConfirmed }
					recipientsViewController.recipientList = recipientsThatHaveRead
				default: break
			}
		} else if let replayViewController = segue.destinationViewController as? ReplayViewController {
			switch identifier {
				case Constants.replayToUserSegue:
					replayViewController.messageId = message.id
					replayViewController.replayType = .ToUser(user: message.sender!)
				case Constants.replyOnReplySegue:
					if let cell = (sender  as? UIView)?.superview?.superview as? UITableViewCell {
						if let indexPath = tableView.indexPathForCell(cell) {
							replayViewController.messageId = repliesList[indexPath.row].id
							replayViewController.replayType = .ToUser(user: repliesList[indexPath.row].sender!)
						}
					}
                case Constants.replyAllSegue:
                    if let indexPath = tableView.indexPathForSelectedRow {
						replayViewController.messageId = repliesList[indexPath.row].id
                        replayViewController.replayType = .ToAll
                    }
				default: break
			}

		}

	}
    
}

// MARK: - UITableViewDataSource

extension MessageDetailViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return repliesList.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellId) as! MessageDetailCommentTableViewCell
		let replyModel = repliesList[indexPath.item]

		let confirmedRecipients = recipientList.objects.filter( { $0.hasConfirmed } )
		replyModel.readConfirmed = confirmedRecipients.filter { $0.employeeId == replyModel.sender?.id }.count > 0
		cell.configureWithReplyModel(replyModel)
		cell.delegate = self

		if (repliesList.count - indexPath.row) <= (ReplyListModel.requestRowCount / 2) && !repliesList.isLoading && !repliesList.loadedAll {
			loadMoreReplies()
		}

		return cell
	}

}

// MARK: - UITableViewDelegate

extension MessageDetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if needsToReloadCell {
            tableView.beginUpdates()
            tableView.endUpdates()
            needsToReloadCell = false
        }
    }
    
}

extension MessageDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y  <= 0 {
               scrollView.backgroundColor = UIColor.whiteColor()
            } else {
                scrollView.backgroundColor = AppColors.dirtyWhite
            }
        }
    }
    
}

extension MessageDetailViewController: MessageDetailCellDelegate {
    
    func didSelectExpandButton() {
        needsToReloadCell = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}
