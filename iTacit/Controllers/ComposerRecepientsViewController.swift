//
//  ComposerRecepientsViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/4/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ComposerRecepientsViewController: UIViewController {
    
    private struct Constants {
        static let HeaderViewHeight: CGFloat = 39
    }
    
    @IBOutlet weak var tableView: UITableView!
    var hiddenSections: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private 
    
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
}

extension ComposerRecepientsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
}

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
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserRecepientTableViewCell") as! UserRecepientTableViewCell
            cell.cellType = UserRecepientCellType.Interactive
            cell.delegate = self;
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserRecepientTableViewCell") as! UserRecepientTableViewCell
            cell.cellType = UserRecepientCellType.Default
            cell.delegate = self;
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView(frame: CGRectZero)
        }
        
        let header = ComposeReportsHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetMaxX(UIScreen.mainScreen().bounds), height: Constants.HeaderViewHeight))
        
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

extension ComposerRecepientsViewController: ComposerHeaderViewDelegate {
    func didSelectCloseButtonInHeaderView(view: UIView) {
        //TODO: handle close button
        if view is ComposeReportsHeaderView {
            print("header")
        } else {
            print("cell")
        }
    }
    
    func didSelectExpandButtonInHeaderView(view: UIView) {
        if view is ComposeReportsHeaderView {
            if let section = (view as! ComposeReportsHeaderView).section {
                showOrHideCellsIn(section: section)
            }
        }
    }
}