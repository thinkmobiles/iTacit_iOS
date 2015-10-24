//
//  NewsViewController.swift
//  iTacit
//
//  Created by Sauron Black on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tagSearchControl: TagSearchControl! {
		didSet {
			tagSearchControl.delegate = self
		}
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		clearSelection()
	}

	private func clearSelection() {
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
		}
	}
	
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath)
        
        return cell
    }
}

extension NewsViewController: TagSearchControlDelegate {

	func tagsSearchControl(tagsSearchControl: TagSearchControl, needsAutocompletionWithCompletion completion: (strings: [String]) -> Void) {
		let strings = ["lorem ipsum", "lorem", "lorem ipsum", "Lorem ipsum dolor"]
		return completion(strings: strings)
	}
}