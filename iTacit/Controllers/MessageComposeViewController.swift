//
//  MessageComposeViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessageComposeViewController: BaseViewController {
    
    private struct Constants {
        static let defaultCellHeight: CGFloat = 42.0
        static let FloatingViewDefaultDownHeith: CGFloat = 30.0
        static let AnimationDuration: Double = 0.2
    }

    @IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var floatingView: MessageComposerFloatingView!
    @IBOutlet weak var floatingViewDownConstraint: NSLayoutConstraint!


	private var reuseIdetifiersDataSource = [ComposerRecipientsTableViewCell.reuseIdentifier, ComposerTopicTableViewCell.reuseIdentifier, ComposerBodyTableViewCell.reuseIdentifier]
    
//    private var dynamicCellReference: UITableViewCell?
    private var messageModel = NewMessageModel()
//    private var isEstimateCellShown = false

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
		tableView.estimatedRowHeight = Constants.defaultCellHeight
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    // MARK: - IBAction
    
    @IBAction func sendMessageAction(sender: UIBarButtonItem) {

    }
    
    @IBAction func showDatePickerButtonAction(sender: UIButton) {
//        if !isEstimateCellShown {
//            isEstimateCellShown = true
//            tableView.reloadData()
//        }
    }
    
    // MARK: Keyboard
    
    override func keyboardWillShowWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, size.height, 0.0)
        
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        
        UIView.animateWithDuration(Constants.AnimationDuration, animations: { () -> Void in
            if self.floatingViewDownConstraint.constant == Constants.FloatingViewDefaultDownHeith {
                self.floatingViewDownConstraint.constant += size.height + 20
                self.view.layoutIfNeeded()
            }
		}, completion: nil)
    }
    
    override func keyboardWillHideWithSize(size: CGSize, animationDuration: NSTimeInterval, animationOptions: UIViewAnimationOptions) {
        view.layoutIfNeeded()
        tableView.contentInset = UIEdgeInsetsZero
        tableView.scrollIndicatorInsets = UIEdgeInsetsZero

		UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: { [weak self] () -> Void in
			self?.floatingViewDownConstraint.constant = Constants.FloatingViewDefaultDownHeith
			self?.view.layoutIfNeeded()
		}, completion: nil)
	}

}

// MARK: - UITableViewDataSource

extension MessageComposeViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reuseIdetifiersDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let reuseIdentifier = reuseIdetifiersDataSource[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
		(cell as? ResizableTableViewCell)?.delegate = self
		return cell
/*
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(ComposerRecipiencTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! ComposerRecipiencTableViewCell
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(ComposerTopicTableViewCell.reuseIdentifier, forIndexPath: indexPath)
            if let custCell = cell as? ComposerTopicTableViewCell {
                custCell.delegate = self
            }
            
            return cell
        } else {
            if isEstimateCellShown && indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ComposerReadDateTableViewCell).componentsSeparatedByString(".").last!, forIndexPath: indexPath)
                
                if let custCell = cell as? ComposerReadDateTableViewCell {
                    custCell.delegate = self
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        custCell.pickedDateTextField?.becomeFirstResponder()
                    })
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ComposerBodyTableViewCell).componentsSeparatedByString(".").last!, forIndexPath: indexPath)
                
                if let custCell = cell as? ComposerBodyTableViewCell {
                    custCell.delegate = self
                }
                
                return cell
            }
        }
		*/
    }
}

// MARK: - UITableViewDelegate

extension MessageComposeViewController: UITableViewDelegate {

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		return UITableViewAutomaticDimension
	}
}

extension MessageComposeViewController: ResizableTableViewCellDelegate {

	func tableVeiwCellNeedsUpdateSize(cell: UITableViewCell) {
		tableView.beginUpdates()
		tableView.endUpdates()
	}
}

extension MessageComposeViewController: ConfirmationCellDelegate {

    func confirmationCellCancelButtonPressed() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
    
    func pickeDate(date: NSDate) {
        messageModel.estimatedDate = date
    }
}