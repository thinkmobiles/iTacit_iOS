//
//  PagingViewController.swift
//  iTacit
//
//  Created by Sauron Black on 11/20/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class PagingViewController: BaseViewController {

	private var numberOfLoadedElements = 0

	var numberOfRequestedItems: Int {
		return PageListModel<NewsModel>.requestRowCount
	}
	var numberOfItems: Int {
		return 0
	}
	var rowHeight: CGFloat {
		return 0
	}

	func reloadData() {
		numberOfLoadedElements = 0
	}

	func loadMoreItems() { }
}

// MARK: - UIScrollViewDelegate

extension PagingViewController: UIScrollViewDelegate {

	func scrollViewDidScroll(scrollView: UIScrollView) {
		let delta = scrollView.contentSize.height - scrollView.contentOffset.y
		let leftCellsHeight = CGFloat((numberOfRequestedItems / 2)) * rowHeight
		if delta <= leftCellsHeight && numberOfLoadedElements < numberOfItems {
			numberOfLoadedElements = numberOfItems
			loadMoreItems()
		}
	}

}
