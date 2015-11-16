//
// Created by Sauron Black on 11/15/15.
// Copyright (c) 2015 iTacit. All rights reserved.
//

import UIKit

class SwipeableTableViewCell: UITableViewCell {

	private struct Constants {
		static let animationDuration = 0.25
		static let translationCoefficient = CGFloat(1.0 / 3.0)
		static let minVelocity = CGFloat(400.0)
	}

	@IBOutlet weak var swipableContainerView: UIView!
	@IBOutlet weak var buttonsContainerView: UIView!
	@IBOutlet weak var swipableContainerViewLeadingConstraint: NSLayoutConstraint!

	private var panGesture: UIPanGestureRecognizer!
	private var tapGesture: UITapGestureRecognizer!
	private var _buttonsHidden = true
	var buttonsHidden: Bool {
		get {
			return _buttonsHidden
		}
		set {
			if newValue {
				hideButtonsAnimated(false)
			} else {
				revealButtonsAnimated(false)
			}
		}
	}

	// MARK: - Lifecycle

	override func awakeFromNib() {
		super.awakeFromNib()
		addGesture()
		selectionStyle = .None
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		buttonsHidden = true
	}

	// MARK: - Public

	func revealButtonsAnimated(animated: Bool) {
		let buttonsContainerWidth = CGRectGetWidth(buttonsContainerView.frame)
		guard swipableContainerViewLeadingConstraint.constant != -buttonsContainerWidth else {
			_buttonsHidden = false
			return
		}

		layoutIfNeeded()
		UIView.animateWithDuration(animated ? Constants.animationDuration : 0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { [weak self] () -> Void in
			self?.swipableContainerViewLeadingConstraint.constant = -buttonsContainerWidth
			self?.layoutIfNeeded()
		}) { [weak self] finished in
			self?._buttonsHidden = false
		}
	}

	func hideButtonsAnimated(animated: Bool) {
		guard swipableContainerViewLeadingConstraint.constant != 0 else {
			_buttonsHidden = true
			return
		}

		layoutIfNeeded()
		UIView.animateWithDuration(animated ? Constants.animationDuration : 0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { [weak self] () -> Void in
			self?.swipableContainerViewLeadingConstraint.constant = 0
			self?.layoutIfNeeded()
		}) { [weak self] finished in
			self?._buttonsHidden = true
		}

	}

	// MARK: - Private

	func panGestureAction(sender: UIPanGestureRecognizer) {
		let translation = sender.translationInView(swipableContainerView)
		let velocity = sender.velocityInView(swipableContainerView)
		let buttonsContainerWidth = CGRectGetWidth(buttonsContainerView.frame)
		switch sender.state {
			case .Changed:
				let shift = min(max(-buttonsContainerWidth, buttonsHidden ? translation.x : (-buttonsContainerWidth + translation.x)), 0.0)
				swipableContainerViewLeadingConstraint.constant = shift
			case .Ended, .Cancelled:
				let a = buttonsHidden, b = abs(velocity.x) > Constants.minVelocity
				let c = abs(translation.x) > (buttonsContainerWidth * Constants.translationCoefficient)
				let hideButtons = !a && b || !a && !b && c || a && !b && !c
				if hideButtons {
					hideButtonsAnimated(true)
				} else {
					revealButtonsAnimated(true)
				}
			default:
				break;
		}
	}

	func tapGestureAction(sender: UIPanGestureRecognizer) {
		if !buttonsHidden {
			hideButtonsAnimated(true)
		}
	}

	private func addGesture() {
		panGesture = UIPanGestureRecognizer(target: self, action: Selector("panGestureAction:"))
		panGesture.delegate = self
		swipableContainerView.addGestureRecognizer(panGesture)
		tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapGestureAction:"))
		tapGesture.delegate = self
		swipableContainerView.addGestureRecognizer(tapGesture)
	}

	// MARK: - UIGestureRecognizerDelegate

	override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer == tapGesture {
			return !buttonsHidden
		} else if let panGestureRecoginzer = gestureRecognizer as? UIPanGestureRecognizer where panGestureRecoginzer == panGesture {
			let translation = panGestureRecoginzer.translationInView(swipableContainerView)
			return fabs(translation.x) > fabs(translation.y)
		} else {
			return super.gestureRecognizerShouldBegin(gestureRecognizer)
		}
	}

}
