//
//  DashboardViewController.swift
//  iTacit
//
//  Created by Sauron Black on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

	private struct Constants {
		static let estimatedRowHeight = CGFloat(85)
	}

	@IBOutlet weak var dashboardTitleLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var feedTitleLabel: UILabel!

	private var pageViewController: UIPageViewController?
	private var timer: NSTimer?
	private var currentBunnerIndex: Int? {
		return (pageViewController?.viewControllers?.first as? BannerViewController)?.pageIndex
	}

	private var bannerList = BannerListModel()
	private var activityFeed = ActivityFeedModel()

	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		feedTitleLabel.text = LocalizedString("RECENT ACTIVITY")
		setUpTableView()
		loadOwnUserProfile()
		updateGreeting()
		loadBanners()
		loadActivityFeed()
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

	private func setUpTableView() {
		tableView.tableFooterView = UIView()
		tableView.estimatedRowHeight = Constants.estimatedRowHeight
		tableView.rowHeight = UITableViewAutomaticDimension
	}

	private func loadOwnUserProfile() {
		let profilesList = UserProfileListModel()
		profilesList.searchQuery = OwnUserProfileQueryModel()
		profilesList.loadOwnUserProfile { [weak self] (success, user) -> Void in
			SharedStorage.sharedInstance.userProfile = user
			self?.updateGreeting()
		}
	}

	private func loadActivityFeed() {
		activityFeed.load { [weak self] (success) -> Void in
			self?.tableView.reloadData()
		}
	}

	private func loadBanners() {
		bannerList.load { [weak self] (success) -> Void in
			guard let strongSelf = self else {
				return
			}
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
		bannerList.loadMore()
	}

	private func scheduleTimerWithTimeInterval(timeInterval: NSTimeInterval) {
		guard bannerList.count > 1 else {
			return
		}
		timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: Selector("showNextBanner"), userInfo: nil, repeats: false)
	}

	private func showBannerAtIndex(index: Int) {
		timer?.invalidate()
		guard index < bannerList.count else {
			return
		}
		if let bannerViewController = bannerViewControllerAtIndex(index) {
			pageViewController?.setViewControllers([bannerViewController], direction: .Forward, animated: true, completion: nil)
		}
		scheduleTimerWithTimeInterval(bannerList[index].displayTime)
	}

	func showNextBanner() {
		guard let currentBannerIndex = currentBunnerIndex else {
			return
		}
		let nextIndex = (currentBannerIndex + 1) % bannerList.count
		showBannerAtIndex(nextIndex)
	}

	private func bannerViewControllerAtIndex(index: Int) -> BannerViewController? {
		guard bannerList.count > 0 && bannerList.count > index else {
			return nil
		}

		let bannerViewController = storyboard?.instantiateViewControllerWithIdentifier(BannerViewController.storyboardId) as? BannerViewController
		bannerViewController?.pageIndex = index
		bannerViewController?.banner = bannerList[index]
		return bannerViewController
	}

	// MARK: - Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let pageViewController = segue.destinationViewController as? UIPageViewController {
			pageViewController.dataSource = self
			self.pageViewController = pageViewController
		}
	}

}

// MARK: - UIPageViewControllerDataSource

extension DashboardViewController: UIPageViewControllerDataSource {

	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		guard var index = (viewController as? BannerViewController)?.pageIndex else {
			return nil
		}
		guard !(index == 0 && bannerList.count == 1) else {
			return nil
		}
		index = index == 0 ? (bannerList.count - 1) : index - 1
		return bannerViewControllerAtIndex(index)
	}

	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		guard var index = (viewController as? BannerViewController)?.pageIndex else {
			return nil
		}
		guard !(index == 0 && bannerList.count == 1) else {
			return nil
		}
		if (bannerList.count - index) <= (BannerListModel.requestRowCount / 2) && !bannerList.isLoading && !bannerList.loadedAll {
			loadMoreBanners()
		}
		index = (index + 1) % bannerList.count
		return bannerViewControllerAtIndex(index)
	}

}

// MARK: - UITableViewDataSource

extension DashboardViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return activityFeed.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(ActivityFeedTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! ActivityFeedTableViewCell
		cell.configureWithActivityFeedItem(activityFeed[indexPath.row])
		return cell
	}

}
