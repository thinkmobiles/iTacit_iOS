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
    }

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var confirmViewImage: UIImageView!
    @IBOutlet weak var confirmViewTitle: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerConfirmToDate: UILabel!
    @IBOutlet weak var replyToAllButton: UIButton!
    @IBOutlet weak var replyToUserButton: UIButton!
    @IBOutlet weak var showMoreTextView: ShowMoreTextView!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var confirmationButtonHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var repicientsButton: UIButton!
	@IBOutlet weak var confirmedRecipientsButton: UIButton!
    
    var replyToUserName: String {
        get {
            return replyToUserButton.titleLabel?.text ?? ""
        }
        set {
            replyToUserButton.setTitle(" " + newValue, forState: .Normal)
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

		recipientList.searchQuery = RecipientSearchQuery(messageId: message.id)
        repliesList.searchQuery = searchQuery
        searchQuery.string = message.id
        showMoreTextView.maximumNumberOfLines = 3
        showMoreTextView.shouldTrim = true
        showMoreTextView.attributedTrimText = NSMutableAttributedString(string: "...")

        prepareUI()
		loadRecipients()
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		loadReplies()
	}
    
    // MARK: - IBAction
    
    @IBAction func confirmedReadAction(sender: UIButton) {
        message.confirm { [unowned self] (success) -> Void in
            if success {
                self.setConfirmed()
            }
        }
    }
    
    @IBAction func replyToAllAction(sender: UIButton) {
        let replyViewController =  storyboard?.instantiateViewControllerWithIdentifier(Constants.ReplyViewControllerID) as! ReplayViewController
        replyViewController.replayType = .ToAll
        replyViewController.messageId = message.id
        navigationController?.pushViewController(replyViewController, animated: true)
    }
    
    @IBAction func replyToUserAction(sender: UIButton) {

    }
    
    // MARK: - Private
    
    private func loadReplies() {
        repliesList.load { [weak self] (success) -> Void in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableView.reloadData()
        }
    }

	private func loadRecipients() {
		recipientList.load { [weak self] (success) -> Void in
			guard let strongSelf = self else {
				return
			}

			strongSelf.repicientsButton.setTitle("  \(strongSelf.recipientList.count)", forState: .Normal)
			let confirmedRecipients = strongSelf.recipientList.objects.filter( { $0.hasConfirmed } )
			strongSelf.confirmedRecipientsButton.setTitle("  \(confirmedRecipients.count)", forState: .Normal)
		}
	}
    
    private func prepareUI() {
        tableViewHeightConstraint.constant = view.frame.height - headerView.frame.height - 64.0

        if let sender = message.sender {
            replyToUserName = sender.firstName
            titleLabel.text = sender.fullName

        }
        
        switch message.readRequirementType {
			case .NotRequired:
				setConfirmed()
			case .RequiredTo(let date):
				headerConfirmToDate.text = LocalizedString("Please confirm By ") + MessageDetailViewController.readToDateFormatter.stringFromDate(date)
				confirmViewTitle.text = LocalizedString("I HAVE READ THIS")
				confirmViewTitle.textColor = AppColors.blue
				confirmViewImage.image = nil
				confirmViewImage.layer.cornerRadius = 9.0
				confirmViewImage.layer.borderColor = AppColors.blue.CGColor
				confirmViewImage.layer.borderWidth = 0.5
        }
        
        if let body = message.body {
            let trimmedBody = body.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

            showMoreTextView.attributedText = NSAttributedString(string: trimmedBody)
        }
        
        timeAgoLabel.text = message.sendDate?.timeAgoStringRepresentation()
        headerTitle.text = message.subject
        confirmationView.layer.borderColor = AppColors.gray.CGColor
        replyToAllButton.setTitle(" " + LocalizedString("All"), forState: .Normal)
    }
    
    private func setConfirmed() {
        confirmationButton.hidden = true
        headerConfirmToDate.text = ""
        confirmViewImage.image = UIImage(assetsIndetifier: AssetsIndetifier.ConfirmedIcon)
        confirmViewTitle.text = LocalizedString("Confirmed read on ") /*+ MessageDetailViewController.readToDateFormatter.stringFromDate(date)*/
        confirmViewImage.layer.borderColor = UIColor.clearColor().CGColor
        confirmViewImage.layer.cornerRadius = 0
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let recipientsViewController = segue.destinationViewController as? RecipientsViewController {
			recipientsViewController.recipientList = recipientList
		} else if let replayViewController = segue.destinationViewController as? ReplayViewController, identifier = segue.identifier {
			switch identifier {
				case Constants.replayToUserSegue:
					replayViewController.messageId = message.id
					replayViewController.replayType = .ToUser(user: message.sender!)
				case Constants.replyOnReplySegue:
					if let indexPath = tableView.indexPathForSelectedRow {
						replayViewController.messageId = repliesList[indexPath.row].id
						replayViewController.replayType = .ToUser(user: repliesList[indexPath.row].sender!)
					}
				default: break
			}

		}

	}
    
}

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

extension MessageDetailViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return repliesList.count
	}

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellId) as! MessageDetailCommentTableViewCell
        let replyModel = repliesList[indexPath.item]
        
        cell.configureWithReplyModel(replyModel)
        cell.delegate = self
        
        return cell
    }
    
}

extension MessageDetailViewController: MessageDetailCellDelegate {
    
    func didSelectExpandButton() {
        needsToReloadCell = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}
