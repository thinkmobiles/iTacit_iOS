//
//  NewsViewController.swift
//  iTacit
//
//  Created by Sauron Black on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

let ImageCache = NSCache()

class NewsViewController: PagingViewController {

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
        newsTitle.text = LocalizedString("News")
	}

	// MARK: - Private

	private func clearSelection() {
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
		}
	}

	private func updateAutocompletionList() {
		tagSearchControl.updateDataSource(autocompletionListForText(tagSearchControl.searchText))
	}

	private func autocompletionListForText(text: String) -> [String] {
		let news = newsList.objects.filter { $0.headline.beginsWithString(text) }
		return news.map { $0.headline }
	}

	func performSearch(sender: NSTimer) {
		reloadData()
	}

	// MARK: - Data reloading

	override var numberOfItems: Int {
		return newsList.count
	}

	override var rowHeight: CGFloat {
		return tableView.rowHeight
	}

	override func loadMoreItems() {
		newsList.loadMore { [weak self] (success) -> Void in
			self?.didLoadData()
		}
	}

	override  func reloadData() {
		super.reloadData()
		newsList.load { [weak self] (success) -> Void in
			self?.didLoadData()
		}
	}

	private func didLoadData() {
		tableView.reloadData()
		updateAutocompletionList()
	}

	// MARK: Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let selectedIndexPath = tableView.indexPathForSelectedRow, newsDetailViewController = segue.destinationViewController as? NewsDetailViewController {
			newsDetailViewController.newsModel = newsList[selectedIndexPath.row]
		} else if let filterNewsViewController = segue.destinationViewController as? FilterNewsViewController {
			filterNewsViewController.searchModel = ((newsList.searchQuery as? SearchNewsQueryModel)?.copy()) ?? SearchNewsQueryModel()
			filterNewsViewController.tags = tagSearchControl.tags
		}
	}

	// MARK: - IBActions

	@IBAction func returnFromFilterViewController(segue: UIStoryboardSegue) {
		if let filterNewsViewController = segue.sourceViewController as? FilterNewsViewController {
			let searchModel = filterNewsViewController.searchModel
			newsList.searchQuery = searchModel
			(newsList.searchQuery as? SearchNewsQueryModel)?.string = tagSearchControl.searchText
			tagSearchControl.tags = filterNewsViewController.tags
			tagSearchControl.showClearButton = (searchModel.startDate != nil) || (searchModel.endDate != nil)
			reloadData()
			guard #available(iOS 9, *) else {
				navigationController?.popViewControllerAnimated(true)
				return
			}
		}
	}
	
	@IBAction func didChangeSearchString(sender: TagSearchControl) {
		(newsList.searchQuery as? SearchNewsQueryModel)?.string = sender.searchText.characters.count >= 3 ? tagSearchControl.searchText: ""
		searchTimer?.invalidate()
		searchTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("performSearch:"), userInfo: nil, repeats: false)
	}

	@IBAction func searchControllDidBeginEditing(sende: TagSearchControl) {
		updateAutocompletionList()
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

// MARK: - TagSearchControlDelegate

extension NewsViewController: TagSearchControlDelegate {

	func tagsSearchControlSearchButtonPressed(tagsSearchControl: TagSearchControl) {
		searchTimer?.invalidate()
		if !tagsSearchControl.searchText.isEmpty {
			reloadData()
		}
	}

	func tagsSearchControlDidClear(tagsSearchControl: TagSearchControl) {
		newsList.searchQuery = SearchNewsQueryModel(string: "")
		reloadData()
	}

	func tagsSearchControlShouldBecameActive(tagsSearchControl: TagSearchControl) -> Bool {
		return true
	}

}
