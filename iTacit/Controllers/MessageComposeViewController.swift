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
        static let DefaultCellHeight: CGFloat = 40.0
        static let FloatingViewDefaultDownHeith: CGFloat = 30.0
        static let AnimationDuration: Double = 0.2
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var floatingViewDownConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingView: MessageComposerFloatingView!
    
    private var dynamicCellReference: UITableViewCell?
    private var messageModel = NewMessageModel()
    private var isEstimateCellShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
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
    
    @IBAction func dismissButtonAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendButtonAction(sender: UIBarButtonItem) {
    }
    
    @IBAction func showDatePickerButtonAction(sender: UIButton) {
        if !isEstimateCellShown {
            isEstimateCellShown = true
            tableView.reloadData()
        }
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

        UIView.animateWithDuration(Constants.AnimationDuration, animations: { () -> Void in
            self.floatingViewDownConstraint.constant = Constants.FloatingViewDefaultDownHeith
            self.view.layoutIfNeeded()

            }, completion: nil)
    }
}

extension MessageComposeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            if let cell = dynamicCellReference as? ComposerTopicTableViewCell {
                cell.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 40.0)
                let size = cell.systemLayoutSizeFittingSize(CGSize(width: (UIScreen.mainScreen().bounds.size.width), height: Constants.DefaultCellHeight), withHorizontalFittingPriority: 1000, verticalFittingPriority: 50)

                return size.height
            }
            
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
    }
}

extension MessageComposeViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEstimateCellShown ? 4 : 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ComposerToTableViewCell).componentsSeparatedByString(".").last!, forIndexPath: indexPath)
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ComposerTopicTableViewCell).componentsSeparatedByString(".").last!, forIndexPath: indexPath)
            if let custCell = cell as? ComposerTopicTableViewCell {
                custCell.delegate = self
            }
            
            return cell
        } else {
            if isEstimateCellShown && indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ComposerRequestConfirmationCell).componentsSeparatedByString(".").last!, forIndexPath: indexPath)
                
                if let custCell = cell as? ComposerRequestConfirmationCell {
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
    }
}

extension MessageComposeViewController: ComposeDynamicCellDelegate {
    func composerCellTopicDidChangeTo(newValue: AnyObject, cell: UITableViewCell) {
        dynamicCellReference = cell
        
        if let _ = cell as? ComposerTopicTableViewCell {
            messageModel.topic = newValue as? String
        }
        if let _ = cell as? ComposerRequestConfirmationCell {
            messageModel.estimatedDate = newValue as? NSDate
        }
        
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        
        CATransaction.setCompletionBlock { () -> Void in
            UIView.setAnimationsEnabled(true)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        CATransaction.commit()
    }
}

extension MessageComposeViewController: ConfirmationCellDelegate {
    func confirmationCellCancelButtonPressed() {
        isEstimateCellShown = false
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
    
    func pickeDate(date: NSDate) {
        messageModel.estimatedDate = date
    }
}