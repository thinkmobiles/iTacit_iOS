//
//  TagsSearchControl.swift
//  TagsSearchControl
//
//  Created by Sauron Black on 10/16/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol TagSearchControlDelegate: class {

	func tagsSearchControl(tagsSearchControl: TagSearchControl, needsAutocompletionWithCompletion completion:(strings: [String]) -> Void)
	func tagsSearchControlSearchButtonPressed(tagsSearchControl: TagSearchControl)
	func tagsSearchControlDidClear(tagsSearchControl: TagSearchControl)

}

class TagSearchControl: UIControl {

	private struct Constants {
		static let nibName = "TagSearchControl"
		static let animationDuratoin = 0.25
	}

	enum Mode {
		case Normal
		case Editing
	}

	@IBOutlet weak var tagTextField: TagTextField!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var clearButton: UIButton!
	@IBOutlet weak var searchButtonLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var autocompletionTableView: UITableView!
	@IBOutlet weak var trailingConstraint: NSLayoutConstraint!

	weak var delegate: TagSearchControlDelegate?

	var tags: [String] {
		return tagTextField.tags
	}

	private(set) var inputText: String {
		get {
			return tagTextField.text
		}
		set {
			tagTextField.text = newValue
		}
	}

	private(set) var mode = Mode.Normal {
		didSet {
			guard oldValue != mode else {
				return
			}
			switch mode {
				case .Normal: setNormalMode()
				case .Editing: setEditingMode()
			}
		}
	}

	var autocompletionStrings = [String]()

	var rightOffset: CGFloat {
		get {
			return trailingConstraint.constant
		}
		set {
			trailingConstraint.constant = newValue
		}
	}

	// MARK: - Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)
		setUp()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setUp()
	}

	// MARK: - IBActions

	@IBAction func activateSearch() {
		mode = .Editing
	}

	@IBAction func clear() {
		tagTextField.clear()
		hideAutocompletionTableView()
		mode = .Normal
		clearButton.hidden = true
		delegate?.tagsSearchControlDidClear(self)
	}
	
	@IBAction func didChangeInputText(sender: TagTextField) {
		if inputText.characters.count >= 3 {
			delegate?.tagsSearchControl(self) { [weak self] (strings) -> Void in
				guard let strongSelf = self else {
					return
				}
				if strongSelf.autocompletionStrings != strings {
					strongSelf.autocompletionStrings = strings
					strongSelf.showAutocompletionTableView()
				} else {
					strongSelf.autocompletionTableView.reloadData()
				}
			}
		} else {
			hideAutocompletionTableView()
		}
		clearButton.hidden = inputText.isEmpty
		sendActionsForControlEvents(.EditingChanged)
	}
	
	// MARK: - Private

	private func showAutocompletionTableView() {
		guard !autocompletionStrings.isEmpty else {
			return
		}
		CATransaction.begin()

		CATransaction.setCompletionBlock { [weak self] () -> Void in
			self?.autocompletionTableView.backgroundColor = UIColor.whiteColor()
		}

		autocompletionTableView.beginUpdates()
		autocompletionTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Top)
		autocompletionTableView.endUpdates()

		CATransaction.commit()
	}

	private func hideAutocompletionTableView() {
		autocompletionStrings = []
		autocompletionTableView.backgroundColor = UIColor.clearColor()
		autocompletionTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Top)
	}

	private func setUp() {
		loadSubviewFromNib()
		tagTextField.delegate = self
		tagTextField.returnKeyType = .Search
		let nib = UINib(nibName: AutocompletionTableViewCell.reuseIdentifier, bundle: nil)
		autocompletionTableView.registerNib(nib, forCellReuseIdentifier: AutocompletionTableViewCell.reuseIdentifier)
	}

	private func loadSubviewFromNib() {
		if let view = NSBundle.mainBundle().loadNibNamed(Constants.nibName, owner: self, options: nil).first as? UIView {
			addEdgePinnedSubview(view)
		}
	}

	private func highlightSubstring(substring: String, inString string: String) -> NSAttributedString {
		let attributedString = NSMutableAttributedString(string: string, attributes: [NSForegroundColorAttributeName: AppColors.lightGray])
		let range = (string as NSString).rangeOfString(substring, options: .CaseInsensitiveSearch)
		if range.location != NSNotFound {
			attributedString.addAttribute(NSForegroundColorAttributeName, value: AppColors.darkGray, range: range)
		}
		return attributedString
	}

	// MARK: - Modes 

	private func setNormalMode() {
		tagTextField.endEditing()
	}

	private func setEditingMode() {
		tagTextField.beginEditing()
	}

	// MARK: - UIView

	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		let convertedPoint = autocompletionTableView.convertPoint(point, fromView: self)
		if CGRectContainsPoint(autocompletionTableView.bounds, convertedPoint) && autocompletionStrings.count > 0 {
			return autocompletionTableView
		}
		return super.hitTest(point, withEvent: event)
	}

}

// MARK: - InputCollectionViewCellDelegate

extension TagSearchControl: TagTextFieldDelegate {

	func tagedTextFieldShouldBeginEditing(textField: TagTextField) -> Bool {
		return mode == .Editing
	}

	func tagedTextFieldDidReturn(textField: TagTextField) {
		hideAutocompletionTableView()
		delegate?.tagsSearchControlSearchButtonPressed(self)
	}

	func tagedTextFieldDidEndEditing(textField: TagTextField) {
		if tags.count == 0 {
			mode = .Normal
		}
		hideAutocompletionTableView()
	}

	func tagedTextFieldShouldInserTag(textField: TagTextField, tag: String) -> Bool {
		return false
	}

	func tagedTextFieldShouldSwitchToCollapsedMode(textField: TagTextField) -> Bool {
		return false
	}
}

extension TagSearchControl: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return autocompletionStrings.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(AutocompletionTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! AutocompletionTableViewCell
		cell.titleLabel.attributedText = highlightSubstring(inputText, inString: autocompletionStrings[indexPath.row])
		return cell
	}
}

extension TagSearchControl: UITableViewDelegate {

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		inputText = autocompletionStrings[indexPath.row]
		hideAutocompletionTableView()
	}
}
