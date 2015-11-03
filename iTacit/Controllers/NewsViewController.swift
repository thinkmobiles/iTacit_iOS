//
//  NewsViewController.swift
//  iTacit
//
//  Created by Sauron Black on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

let ImageCache = NSCache()

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTitle: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tagSearchControl: TagSearchControl! {
		didSet {
			tagSearchControl.delegate = self
		}
	}

	private let newsList = NewsListModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.tableFooterView = UIView()
		reloadData()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		clearSelection()
        
        newsTitle.text = LocalizationService.LocalizedString("News")
	}

	private func clearSelection() {
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
		}
	}

	private func reloadData() {
		newsList.load { [weak self] (success) -> Void in
			self?.tableView.reloadData()
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let selectedIndexPath = tableView.indexPathForSelectedRow, newsDetailViewController = segue.destinationViewController as? NewsDetailViewController {
			newsDetailViewController.newsModel = newsList[selectedIndexPath.row]
		} else if let filterNewsViewController = segue.destinationViewController as? FilterNewsViewController {
			filterNewsViewController.searchString = tagSearchControl.inputText
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
        return newsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
		let newsModel = newsList[indexPath.item]
		cell.title = newsModel.headline
		cell.newsCategoryLabel.text = newsModel.categoryName

		if let imageURL = newsModel.headlineImageURL {
			cell.imageDownloadTask?.cancel()
			cell.imageDownloadTask = ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { (image) -> Void in
				cell.newsImage = image
			})
		} else {
			cell.newsImage = nil
		}

        return cell
    }
}

extension NewsViewController: TagSearchControlDelegate {

	func tagsSearchControl(tagsSearchControl: TagSearchControl, needsAutocompletionWithCompletion completion: (strings: [String]) -> Void) {
		let strings = ["lorem ipsum", "lorem", "lorem ipsum", "Lorem ipsum dolor"]
		return completion(strings: strings)
	}

	func tagsSearchControlSearchButtonPressed(tagsSearchControl: TagSearchControl) {
		if !tagsSearchControl.inputText.isEmpty {
			newsList.searchQuery = SearchNewsQueryModel(string: tagsSearchControl.inputText)
			reloadData()
		}
	}

	func tagsSearchControlDidClear(tagsSearchControl: TagSearchControl) {
		newsList.searchQuery = nil
		reloadData()
	}

}
