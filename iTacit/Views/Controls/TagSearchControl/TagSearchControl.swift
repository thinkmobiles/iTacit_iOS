//
//  TagsSearchControl.swift
//  TagsSearchControl
//
//  Created by Sauron Black on 10/16/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol TagSearchControlDelegate: class {

	func tagsSearchControlSearchButtonPressed(tagsSearchControl: TagSearchControl)
	func tagsSearchControlDidClear(tagsSearchControl: TagSearchControl)
	func tagsSearchControlShouldBecameActive(tagsSearchControl: TagSearchControl) -> Bool

}

class TagSearchControl: UIControl {

	typealias SuggestedItem = String

	private struct Constants {
		static let nibName = "TagSearchControl"
	}

	@IBOutlet weak var tagTextField: TagTextField!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var clearButton: UIButton!
	@IBOutlet weak var searchButtonLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var autocompletionTableView: UITableView!
	@IBOutlet weak var autocompletionTableViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var trailingConstraint: NSLayoutConstraint!
	@IBOutlet weak var topSeparatorView: UIView!

	var allowActivation = true
	var autocompletionDataSource = [SuggestedItem]()
	let numberOfVisibleCells = 3

	var rightOffset: CGFloat {
		get {
			return trailingConstraint.constant
		}
		set {
			trailingConstraint.constant = newValue
		}
	}

	weak var delegate: TagSearchControlDelegate?

	var tags: [TagModel] {
		get {
			return tagTextField.tags
		}
		set {
			tagTextField.tags = newValue
			tagTextField.mode = newValue.isEmpty ? .Editing: .Collapsed
			searchButtonLeadingConstraint.constant = newValue.isEmpty ? 0: -CGRectGetWidth(searchButton.frame)
			tagTextField.reloadData()
			updateClearButtonvisibility()
		}
	}

	var searchText: String {
		get {
			return tagTextField.text
		}
		set {
			tagTextField.mode = .Editing
			tagTextField.reloadData()
			tagTextField.text = newValue
			updateClearButtonvisibility()
		}
	}

	var isEditing = false

	var showClearButton = false {
		didSet {
			updateClearButtonvisibility()
		}
	}

	var topSeparatorHidden: Bool {
		get {
			return topSeparatorView.hidden
		}
		set {
			topSeparatorView.hidden = newValue
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

	// MARK: - Public

	func beginEditing() {
		tagTextField.beginEditing()
	}

	func endEditing() {
		tagTextField.endEditing()
	}

	// MARK: - IBActions

	@IBAction func activateSearch() {
		let shouldBecomeActive = delegate?.tagsSearchControlShouldBecameActive(self) ?? true
		if shouldBecomeActive {
			beginEditing()
		}
	}

	@IBAction func clear() {
		endEditing()
		tags = []
		tagTextField.clear()
		hideAutocompletionTableView()
		updateClearButtonvisibility()
		delegate?.tagsSearchControlDidClear(self)
		showClearButton = false
	}
	
	@IBAction func didChangeInputText(sender: TagTextField) {
		updateClearButtonvisibility()
		sendActionsForControlEvents(.EditingChanged)
	}

	// MARK: - Private

	private func updateClearButtonvisibility() {
		clearButton.hidden = searchText.isEmpty && tags.isEmpty && !showClearButton
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

	// MARK: - UIView

	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		let convertedPoint = autocompletionTableView.convertPoint(point, fromView: self)
		if CGRectContainsPoint(autocompletionTableView.bounds, convertedPoint) && autocompletionDataSource.count > 0 {
			return autocompletionTableView
		}
		return super.hitTest(point, withEvent: event)
	}

}

// MARK: - TagTextFieldDelegate

extension TagSearchControl: TagTextFieldDelegate {

	func tagedTextFieldShouldBeginEditing(textField: TagTextField) -> Bool {
		return tags.isEmpty && allowActivation
	}

	func tagedTextFieldDidReturn(textField: TagTextField) {
		hideAutocompletionTableView()
		delegate?.tagsSearchControlSearchButtonPressed(self)
		tagTextField.endEditing()
	}

	func tagedTextFieldDidBeginEditing(textField: TagTextField) {
		isEditing = true
		sendActionsForControlEvents(.EditingDidBegin)
	}

	func tagedTextFieldDidEndEditing(textField: TagTextField) {
		isEditing = false
		hideAutocompletionTableView()
		sendActionsForControlEvents(.EditingDidEnd)
	}

	func tagedTextFieldShouldInserTag(textField: TagTextField, tag: String) -> Bool {
		return false
	}

	func tagedTextFieldShouldSwitchToCollapsedMode(textField: TagTextField) -> Bool {
		return false
	}

	func tagedTextField(textField: TagTextField, didDeleteTag tag: TagModel) {
		updateClearButtonvisibility()
	}

	func tagedTextField(textField: TagTextField, didChangeContentSize contentSize: CGSize) {}

}

// MARK: - UITableViewDataSource

extension TagSearchControl: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return autocompletionDataSource.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(AutocompletionTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! AutocompletionTableViewCell
		cell.titleLabel.attributedText = highlightSubstring(searchText, inString: autocompletionDataSource[indexPath.row])
		return cell
	}

}

// MARK: - UITableViewDelegate

extension TagSearchControl: UITableViewDelegate {

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		searchText = autocompletionDataSource[indexPath.row]
		sendActionsForControlEvents(.EditingChanged)
		hideAutocompletionTableView()
	}

}

// MARK: - Autocompletable

extension TagSearchControl: Autocompletable {

	func willShowAutocompletion() { }

	func shoudShowAutocompletion() -> Bool {
		return searchText.characters.count >= 3 && isEditing
	}

}
