//
//  Autocompletable.swift
//  iTacit
//
//  Created by Sauron Black on 11/9/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol Autocompletable: class {

	typealias SuggestedItem

	weak var autocompletionTableView: UITableView! { get set }
	weak var autocompletionTableViewHeightConstraint: NSLayoutConstraint! { get set }
	var autocompletionDataSource: [SuggestedItem] { get set }
	var numberOfVisibleCells: Int { get }

	func shoudShowAutocompletion() -> Bool
	func willShowAutocompletion()
	
}

extension Autocompletable {

	func showAutocompletionTableView() {
		guard !autocompletionDataSource.isEmpty else {
			return
		}

		willShowAutocompletion()
		
		let multiplier = CGFloat(min(autocompletionDataSource.count, numberOfVisibleCells))
		autocompletionTableViewHeightConstraint.constant = autocompletionTableView.rowHeight * multiplier

		CATransaction.begin()

		CATransaction.setCompletionBlock { [weak self] () -> Void in
			self?.autocompletionTableView.backgroundColor = UIColor.whiteColor()
		}

		autocompletionTableView.beginUpdates()
		autocompletionTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Top)
		autocompletionTableView.endUpdates()

		CATransaction.commit()
	}

	func hideAutocompletionTableView() {
		autocompletionDataSource = []
		autocompletionTableView.backgroundColor = UIColor.clearColor()
		autocompletionTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Top)
	}

}

extension Autocompletable where SuggestedItem: Equatable {

	func updateDataSource(items: [SuggestedItem]) {
		if shoudShowAutocompletion() && !items.isEmpty {
			if autocompletionDataSource != items {
				autocompletionDataSource = items
				showAutocompletionTableView()
			} else {
				autocompletionTableView.reloadData()
			}
		} else {
			hideAutocompletionTableView()
		}
	}
	
}
