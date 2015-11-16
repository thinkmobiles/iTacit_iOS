//
//  TagedTextField.swift
//  TagsSearchControl
//
//  Created by Sauron Black on 10/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol TagTextFieldDelegate: class {

	func tagedTextFieldShouldBeginEditing(textField: TagTextField) -> Bool
	func tagedTextFieldDidReturn(textField: TagTextField)
	func tagedTextFieldDidBeginEditing(textField: TagTextField)
	func tagedTextFieldDidEndEditing(textField: TagTextField)
	func tagedTextFieldShouldInserTag(textField: TagTextField, tag: String) -> Bool
	func tagedTextFieldShouldSwitchToCollapsedMode(textField: TagTextField) -> Bool
	func tagedTextField(textField: TagTextField, didDeleteTag tag: TagModel)
	func tagedTextField(textField: TagTextField, didChangeContentSize contentSize: CGSize)

}

class TagTextField: UIControl {

	static let CollectionViewContentSizeContext = UnsafeMutablePointer<Void>()

	private struct Constants {
		static let minInputCellWidth = CGFloat(20)
		static let contentSizeKeyPath = "contentSize"
	}

	enum Mode {
		case Editing
		case Collapsed
	}

	private lazy var sizingInputCell: InputCollectionViewCell = {
		NSBundle.mainBundle().loadNibNamed(InputCollectionViewCell.reuseIdentifier, owner: self, options: nil).first as! InputCollectionViewCell
	}()

	private lazy var sizingTextCell: TextCollectionViewCell = {
		NSBundle.mainBundle().loadNibNamed(TextCollectionViewCell.reuseIdentifier, owner: self, options: nil).first as! TextCollectionViewCell
	}()

	private weak var collectionView: UICollectionView!
	private weak var inputCell: InputCollectionViewCell?

	private var collectionViewLayout: CollectionViewLeftAlignedFlowLayout!
	private var tagsShortArray = [TagModel]()
	private var tagsShortArrayAppendix: String?

	private var tagsArray: [TagModel] {
		switch mode {
			case .Collapsed:
				if let tagsShortArrayAppendix = tagsShortArrayAppendix {
					return tagsShortArray + [TagModel(string: tagsShortArrayAppendix, attributes: nil)]
				} else {
					return tagsShortArray
				}
			case .Editing: return tags
		}
	}

	private var hasSpaceForInputCell = false

	var mode = Mode.Collapsed

	var tags = [TagModel]() {
		didSet {
			createTagsShortArray()
		}
	}

	weak var delegate: TagTextFieldDelegate?

	var text: String {
		get {
			return inputCell?.text ?? ""
		}
		set {
			inputCell?.text = newValue
			collectionViewLayout.invalidateLayout()
		}
	}

	var returnKeyType = UIReturnKeyType.Default
	var edgeInsets = UIEdgeInsetsZero {
		didSet {
			collectionViewLayout.sectionInsets = edgeInsets
			collectionViewLayout.invalidateLayout()
		}
	}

	var contentSize: CGSize {
		return collectionView.contentSize
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

	deinit {
		collectionView.removeObserver(self, forKeyPath: Constants.contentSizeKeyPath, context: TagTextField.CollectionViewContentSizeContext)
	}

	// MARK: - Public

	func reloadData() {
		collectionView.reloadData()
		collectionView.layoutIfNeeded()
	}

	func insertTag(tagString: String, attributes: [String: String]? = nil, clearInputText: Bool = true, completion: (() -> Void)? = nil) {
		guard !tagString.isEmptyOrWhitespaces else {
			return
		}

		if clearInputText {
			inputCell?.text = ""
			inputCell?.cursorColor = UIColor.whiteColor()
		}

		tags.append(TagModel(string: tagString, attributes: attributes))
		let indexPath = NSIndexPath(forItem: tags.count - 1, inSection: 0)
		collectionView.performBatchUpdates({ [weak self] () -> Void in
			self?.collectionView.insertItemsAtIndexPaths([indexPath])
		}) { [weak self] finished in
			self?.collectionView.collectionViewLayout.invalidateLayout()
			self?.scrollToBottom()
			self?.inputCell?.cursorColor = AppColors.darkGray
			completion?()
		}
	}

	func removeTag(tag: TagModel, completion: (() -> Void)? = nil) {
		if let index = tagsArray.indexOf(tag) {
			tags.removeAtIndex(index)
			collectionView.performBatchUpdates({ [weak self] () -> Void in
				self?.collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
			}) { (finished) -> Void in
				completion?()
			}
		} else if case .Collapsed = mode {
			if let index = tagsArray.indexOf(tag) {
				tags.removeAtIndex(index)
				createTagsShortArray()
				collectionView.reloadData()
			}
			completion?()
		}
	}

	func beginEditing() {
		beginEditing(true)
	}

	func beginEditing(scrollToBottom: Bool) {
		let shouldBeginEditing = delegate?.tagedTextFieldShouldBeginEditing(self) ?? true
		guard shouldBeginEditing else {
			return
		}
		mode = .Editing
		collectionView.reloadData()
		collectionView.layoutIfNeeded()
		if scrollToBottom {
			collectionView.setContentOffset(CGPoint(x: 0, y: max(0, (collectionView.contentSize.height - CGRectGetHeight(collectionView.frame)))), animated: false)
			collectionView.layoutIfNeeded()
		} 
		inputCell?.textField.tintColor = AppColors.darkGray
		inputCell?.textField.becomeFirstResponder()
	}

	func endEditing() {
		inputCell?.textField.resignFirstResponder()
	}

	func clear() {
		mode = .Collapsed
		tags = []
		tagsShortArray = []
		tagsShortArrayAppendix = nil
		inputCell?.text = ""
		collectionView.reloadData()
	}

	// MARK: - Private

	private func setUp() {
		collectionViewLayout = CollectionViewLeftAlignedFlowLayout()
		collectionViewLayout.itemSize = CGSize(width: 50, height: 27)
		collectionViewLayout.itemsSpacing = 10
		collectionViewLayout.lineSpacing = 6
		collectionViewLayout.sectionInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
		let aCollectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
		addEdgePinnedSubview(aCollectionView)
		collectionView = aCollectionView
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.backgroundColor = UIColor.whiteColor()
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
		collectionView.addObserver(self, forKeyPath: Constants.contentSizeKeyPath, options: [.Old, .New], context: TagTextField.CollectionViewContentSizeContext)
		registerCells()
		setupTapGesture()
	}

	private func setupTapGesture() {
		collectionView.backgroundView = UIView()
		let gesture = UITapGestureRecognizer(target: self, action: Selector("beginEditing"))
		collectionView.backgroundView?.addGestureRecognizer(gesture)
	}

	private func registerCells() {
		let inputCellNib = UINib(nibName: InputCollectionViewCell.reuseIdentifier, bundle: nil)
		collectionView.registerNib(inputCellNib, forCellWithReuseIdentifier: InputCollectionViewCell.reuseIdentifier)
		let textCellNib = UINib(nibName: TextCollectionViewCell.reuseIdentifier, bundle: nil)
		collectionView.registerNib(textCellNib, forCellWithReuseIdentifier: TextCollectionViewCell.reuseIdentifier)
	}

	private func scrollToBottom() {
		let indexPath = NSIndexPath(forItem: tags.count, inSection: 0)
		collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredVertically, animated: true)
	}

	private func contentSizeForArray(array: [String]) -> CGSize {
		let layout = collectionViewLayout
		var y = layout.sectionInsets.top
		let rightEdge = CGRectGetWidth(collectionView.frame) - layout.sectionInsets.right
		var x = layout.sectionInsets.left
		var maxWidth = CGFloat(0)
		for item in 0..<array.count {
			let size = sizeForTextInTextCell(array[item])
			if x + size.width > rightEdge {
				y +=  (layout.lineSpacing + size.height)
				x = layout.sectionInsets.left
			}
			maxWidth = max(maxWidth, (x + size.width))
			x += layout.itemsSpacing + size.width
		}
		y += (layout.itemSize.height + layout.sectionInsets.bottom)
		let contentSize = CGSize(width: maxWidth, height: y)
		return contentSize
	}

	private func createTagsShortArray() {
		tagsShortArrayAppendix = nil
		guard !tags.isEmpty else {
			tagsShortArray = []
			return
		}
		let collectionViewHeight = CGRectGetHeight(collectionView.frame)
		var tagStirngs = tags.map { $0.string }
		if contentSizeForArray(tagStirngs).height <= collectionViewHeight {
			tagsShortArray = tags
			if !text.isEmpty {
				tagStirngs.append(String(text.characters.dropLast()))
				hasSpaceForInputCell = contentSizeForArray(tagStirngs).height <= collectionViewHeight
			} else {
				hasSpaceForInputCell = true
			}
			return
		}
		var i = 0
		var contentSize = CGSizeZero
		while contentSize.height <= collectionViewHeight && i < tags.count {
			var array = tags[0...i].map { $0.string }
			array += ["+\((tags.count - (i + 1)))..."]
			contentSize = contentSizeForArray(array)
			i++
		}
		i -= 2
		tagsShortArray = i >= 0 ? Array(tags[0...i]): []
		tagsShortArrayAppendix = "+\((tags.count - (i + 1)))..."
	}

	private func sizeForTextInTextCell(text: String) -> CGSize {
		let maxWidth = CGRectGetWidth(collectionView.frame) - collectionViewLayout.sectionInsets.left - collectionViewLayout.sectionInsets.right
		let height = collectionViewLayout.itemSize.height
		sizingTextCell.text = text
		let size = sizingTextCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
		return CGSize(width: min(maxWidth, size.width), height: height)
	}

	private func sizeForTextInInputCell(text: String) -> CGSize {
		let maxWidth = CGRectGetWidth(collectionView.frame) - collectionViewLayout.sectionInsets.left - collectionViewLayout.sectionInsets.right
		let height = collectionViewLayout.itemSize.height
		sizingInputCell.text = text + " "
		let size = sizingInputCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
		let width = min(maxWidth, max(Constants.minInputCellWidth, size.width))
		return CGSize(width: width, height: height)
	}

	private func deleteSelectedCellIfNeeded() {
		if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
			inputCell?.cursorColor = AppColors.darkGray
			let tag = tags[selectedIndexPath.item]
			removeTag(tag)
			delegate?.tagedTextField(self, didDeleteTag: tag)
		}
	}

	// MARK: - KVO

	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if context == TagTextField.CollectionViewContentSizeContext {
			let oldSizeValue = change?[NSKeyValueChangeOldKey] as? NSValue
			let newSizeValue = change?[NSKeyValueChangeNewKey] as? NSValue
			if let oldSize = oldSizeValue?.CGSizeValue(), newSize = newSizeValue?.CGSizeValue() where oldSize.height != newSize.height {
				delegate?.tagedTextField(self, didChangeContentSize: newSize)
			}
		} else {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
		}
	}

}

// MARK: - UICollectionViewDataSource

extension TagTextField: UICollectionViewDataSource {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch mode {
			case .Collapsed: return hasSpaceForInputCell ? tagsArray.count + 1 : tagsArray.count
			case .Editing: return tagsArray.count + 1
		}
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if indexPath.row < tagsArray.count {
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! TextCollectionViewCell
			cell.text = tagsArray[indexPath.row].string
			return cell
		} else {
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(InputCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! InputCollectionViewCell
			cell.delegate = self
			cell.textField.delegate = self
			cell.textField.returnKeyType = returnKeyType
			inputCell = cell
			return cell
		}
	}

}

// MARK: - UICollectionViewDelegateFlowLayout

extension TagTextField: CollectionViewDelegateLeftAlignedFlowLayout {

	func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		switch mode {
			case .Editing: return true
			case .Collapsed:
				let shouldBeginEditing = delegate?.tagedTextFieldShouldBeginEditing(self) ?? true
				if indexPath.item == (tagsArray.count - 1) && tags.count > tagsShortArray.count && shouldBeginEditing {
					beginEditing(true)
					return false
				} else {
					return false
				}

		}
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		inputCell?.cursorColor = UIColor.whiteColor()
		inputCell?.text = ""
		sendActionsForControlEvents(.EditingChanged)
	}

	func collectionView(collectionView: UICollectionView, layout: CollectionViewLeftAlignedFlowLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		if indexPath.row < tagsArray.count {
			return sizeForTextInTextCell(tagsArray[indexPath.row].string)
		} else {
			return sizeForTextInInputCell(text)
		}

	}

}

// MARK: - InputCollectionViewCellDelegate

extension TagTextField: InputCollectionViewCellDelegate {

	func inputCollectionViewCellDidChangeText(cell: InputCollectionViewCell) {
		collectionView.collectionViewLayout.invalidateLayout()
		scrollToBottom()
		sendActionsForControlEvents(.EditingChanged)
	}

	func didTapInInputCollectionViewCell(cell: InputCollectionViewCell) {
		if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
			collectionView.deselectItemAtIndexPath(selectedIndexPath, animated: false)
			inputCell?.resetTextField()
		}
	}

}

// MARK: - UITextFieldDelegate

extension TagTextField: ExtendedTextFieldDelegate {

	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		return delegate?.tagedTextFieldShouldBeginEditing(self) ?? true
	}

	func textFieldDidBeginEditing(textField: UITextField) {
		delegate?.tagedTextFieldDidBeginEditing(self)
		sendActionsForControlEvents(.EditingDidBegin)
	}

	func textFieldDidEndEditing(textField: UITextField) {
		let shoudlSwitchMode = delegate?.tagedTextFieldShouldSwitchToCollapsedMode(self) ?? true
		if shoudlSwitchMode {
			mode = .Collapsed
			createTagsShortArray()
			collectionView.reloadData()
		}
		delegate?.tagedTextFieldDidEndEditing(self)
	}

	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		deleteSelectedCellIfNeeded()
		return true
	}

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		defer {
			delegate?.tagedTextFieldDidReturn(self)
		}
		guard let cell = inputCell else {
			return false
		}
		let shouldInserTag = delegate?.tagedTextFieldShouldInserTag(self, tag: cell.text) ?? true
		if shouldInserTag {
			insertTag(cell.text) { [weak self] in
				self?.sendActionsForControlEvents(.ValueChanged)
			}
		}
		return false
	}

	func didPressBackspaceInTextField(textField: ExtendedTextField) {
		deleteSelectedCellIfNeeded()
	}

}
