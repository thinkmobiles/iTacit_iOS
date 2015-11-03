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
	private var searchTimer: NSTimer?

	// MARK: - LifeCycle

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.tableFooterView = UIView()
		newsList.searchQuery = SearchNewsQueryModel(string: "")
		reloadData()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		clearSelection()
        
        newsTitle.text = LocalizationService.LocalizedString("News")
	}

	// MARK: - Private

	private func clearSelection() {
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
		}
	}

	private func reloadData() {
		print("Search query: \(newsList.searchQuery?.stringQuery)")
		newsList.load { [weak self] (success) -> Void in
			self?.tableView.reloadData()
			self?.tagSearchControl?.updateAutocompletionIfNeeded()
		}
	}

	func performSearch(sender: NSTimer) {
		reloadData()
	}

	// MARK: Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let selectedIndexPath = tableView.indexPathForSelectedRow, newsDetailViewController = segue.destinationViewController as? NewsDetailViewController {
			newsDetailViewController.newsModel = newsList[selectedIndexPath.row]
		} else if let filterNewsViewController = segue.destinationViewController as? FilterNewsViewController {
			filterNewsViewController.searchString = tagSearchControl.inputText
		}
	}

	@IBAction func returnFromFilterViewController(segue: UIStoryboardSegue) {
		if let filterNewsViewController = segue.sourceViewController as? FilterNewsViewController {
			newsList.searchQuery = filterNewsViewController.searchModel
			tagSearchControl.tags = filterNewsViewController.tags
			tagSearchControl.mode = .Tags
			reloadData()
		}
	}
	
	@IBAction func didChangeSearchString(sender: TagSearchControl) {
		(newsList.searchQuery as? SearchNewsQueryModel)?.string = tagSearchControl.inputText
		searchTimer?.invalidate()
		if sender.inputText.characters.count >= 3 {
			searchTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("performSearch:"), userInfo: nil, repeats: false)
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
        
        if let startDate = newsModel.startDate {
            cell.timeLabel.text = startDate.timeAgoStringRepresentation()
        }
        
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
		let news = newsList.objects.filter { $0.headline.beginsWithString(tagSearchControl.inputText) }
		let strings = news.map { $0.headline }
		return completion(strings: strings)
	}

	func tagsSearchControlSearchButtonPressed(tagsSearchControl: TagSearchControl) {
		if !tagsSearchControl.inputText.isEmpty {
			(newsList.searchQuery as? SearchNewsQueryModel)?.string = tagSearchControl.inputText
			reloadData()
		}
	}

	func tagsSearchControlDidClear(tagsSearchControl: TagSearchControl) {
		newsList.searchQuery = SearchNewsQueryModel(string: "")
		reloadData()
	}

}
