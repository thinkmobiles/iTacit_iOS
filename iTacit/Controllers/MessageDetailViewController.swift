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
    }

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
    
    var replyToUserName: String {
        get {
            return replyToUserButton.titleLabel?.text ?? ""
        }
        set {
            replyToUserButton.setTitle(" " + newValue, forState: .Normal)
        }
    }

	var message: MessageModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableViewHeight()
        prepareUI()
        
        showMoreTextView.maximumNumberOfLines = 3
        showMoreTextView.shouldTrim = true
        showMoreTextView.attributedTrimText = NSMutableAttributedString(string: "...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBAction
    
    @IBAction func confirmedReadAction(sender: UIButton) {
        setConfirmed()
    }
    
    @IBAction func replyToAllAction(sender: UIButton) {
    }
    
    @IBAction func replyToUserAction(sender: UIButton) {
    }
    
    // MARK: - Private
    
    private func prepareUI() {
        titleLabel.sizeToFit()
        confirmationView.layer.borderColor = AppColors.gray.CGColor
        replyToAllButton.setTitle(" " + LocalizedString("All"), forState: .Normal)
        replyToUserName = "sdfs"
    }
    
    private func prepareTableViewHeight() {
        if UIScreen.mainScreen().bounds.height == Constants.Iphone_3_5 {
            tableViewHeightConstraint.constant = Constants.CellHeight * Constants.NumberOfRowsFor_3_5
        } else {
            tableViewHeightConstraint.constant = Constants.CellHeight * Constants.DefaultNumberOfRows
        }
    }
    
    private func setConfirmed() {
        confirmViewTitle.text = LocalizedString("I HAVE READ THIS")
        confirmViewTitle.textColor = AppColors.blue
        confirmViewImage.image = nil
        confirmViewImage.layer.cornerRadius = 9.0
        confirmViewImage.layer.borderColor = AppColors.blue.CGColor
        confirmViewImage.layer.borderWidth = 0.5
        headerConfirmToDate.text = ""
    }
    
}

extension MessageDetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.CellHeight
    }
    
}

extension MessageDetailViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellId)
        
        return cell!
    }
    
}