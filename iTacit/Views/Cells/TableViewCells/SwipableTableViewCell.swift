//
// Created by Sauron Black on 11/15/15.
// Copyright (c) 2015 iTacit. All rights reserved.
//

import UIKit

class SwipableTableViewCell: UITableViewCell {

	private struct Constants {
		static let animationDuration = 0.25
		static let translationCoefficient = CGFloat(1.0 / 3.0)
		static let minVelocity = CGFloat(400.0)
	}

	@IBOutlet weak var swipableContainerView: UIView!
	@IBOutlet weak var buttonsContatinerView: UIView!
	@IBOutlet weak var swipableContainerViewLeadingConstraint: NSLayoutConstraint!

	private var _buttonsHidden = true
	var buttonHidden: Bool {
		get {
			return _buttonsHidden
		}
		set {
			_buttonsHidden = newValue
			if _buttonsHidden {
				hideButtonsAnimated(true)
			} else {
				revealButtonsAnimated(true)
			}
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		addGesture()
	}

	func revealButtonsAnimated(animated: Bool) {

	}

	func hideButtonsAnimated(animated: Bool) {

	}

	func dragContainer(sender: UIPanGestureRecognizer) {
		let translation = sender.translationInView(swipableContainerView)
		let velocity = sender.velocityInView(swipableContainerView)
		let buttonsContainerWidth = CGRectGetWidth(swipableContainerView.frame)
		switch sender.state {
			case .Changed:
				swipableContainerViewLeadingConstraint.constant = max(-buttonsContainerWidth, min(0.0, buttonHidden ? translation.x: buttonsContainerWidth - translation.x))
			case .Ended, .Cancelled:
				let a = buttonHidden, b = abs(velocity.x) > Constants.minVelocity
				let c = abs(translation.x) > (buttonsContainerWidth * Constants.translationCoefficient)
				buttonHidden = !a && b || !a && !b && c || a && !b && !c
			default:
				break;
		}
	}

	private func addGesture() {
		let panGesture = UIPanGestureRecognizer(target: self, action: Selector("dragContainer"))
		panGesture.delegate = self
		swipableContainerView.addGestureRecognizer(panGesture)
	}

	override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

}

