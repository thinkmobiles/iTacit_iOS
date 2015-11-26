//
//  DashboardViewController.swift
//  iTacit
//
//  Created by Sauron Black on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

	@IBOutlet weak var dashboardTitleLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var feedTitleLabel: UILabel!

	private var timer: NSTimer?
	private var currentBunnerIndex: Int? {
		return collectionView.indexPathsForVisibleItems().first?.item
	}

	var bannerList = BannerListModel()

	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		feedTitleLabel.text = LocalizedString("RECENT ACTIVITY")
		tableView.tableFooterView = UIView()
		loadOwnUserProfile()
		updateGreeting()
		loadBanners()
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		timer?.invalidate()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if let currentBunnerIndex = currentBunnerIndex {
			scheduleTimerWithTimeInterval(bannerList[currentBunnerIndex].displayTime)
		}
	}

	// MARK: - Private

	private func loadOwnUserProfile() {
		let profilesList = UserProfileListModel()
		profilesList.searchQuery = OwnUserProfileQueryModel()
		profilesList.loadOwnUserProfile { [weak self] (success, user) -> Void in
			SharedStorage.sharedInstance.userProfile = user
			self?.updateGreeting()
		}
	}

	private func loadBanners() {
		bannerList.load { [weak self] (success) -> Void in
			guard let strongSelf = self else {
				return
			}
			strongSelf.bannerList.objects += strongSelf.bannerList.objects
			strongSelf.bannerList.objects += strongSelf.bannerList.objects
			strongSelf.collectionView.reloadData()
			if strongSelf.bannerList.count > 0 {
				strongSelf.showBannerAtIndex(0)
			}
		}
	}

	private func updateGreeting() {
		guard let userProfile = SharedStorage.sharedInstance.userProfile else {
			dashboardTitleLabel.text = ""
			return
		}
		dashboardTitleLabel.text = GreetingManager.sharedInstance.greeting.localizedString + ", " + userProfile.firstName
	}

	private func loadMoreBanners() {
		bannerList.loadMore { [weak self] (success) -> Void in
			self?.collectionView.reloadData()
		}
	}

	private func scheduleTimerWithTimeInterval(timeInterval: NSTimeInterval) {
		guard bannerList.count > 1 else {
			return
		}
		print("Banner display time: \(timeInterval)")
		timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("showNextBanner"), userInfo: nil, repeats: false)
	}

	private func showBannerAtIndex(index: Int) {
		timer?.invalidate()
		guard index < bannerList.count else {
			return
		}
		collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .None, animated: true)
		scheduleTimerWithTimeInterval(bannerList[index].displayTime)
	}

	func showNextBanner() {
		guard let currentBannerIndex = currentBunnerIndex else {
			return
		}
		let nextIndex = (currentBannerIndex + 1) % bannerList.count
		showBannerAtIndex(nextIndex)
	}

}

// MARK: - UICollectionViewDataSource

extension DashboardViewController: UICollectionViewDataSource {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return bannerList.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(BannerCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! BannerCollectionViewCell
		cell.configureWithBanner(bannerList[indexPath.row])
		if (bannerList.count - indexPath.row) <= (BannerListModel.requestRowCount / 2) && !bannerList.isLoading && !bannerList.loadedAll {
			loadMoreBanners()
		}
		return cell
	}

}

// MARK: - UICollectionViewDelegateFlowLayout

extension DashboardViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSize(width: CGRectGetWidth(collectionView.frame), height: CGRectGetHeight(collectionView.frame))
	}

}
