//
//  CollectionViewLeftAlignedFlowLayout.swift
//  TagsSearchControl
//
//  Created by Sauron Black on 10/20/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol CollectionViewDelegateLeftAlignedFlowLayout: UICollectionViewDelegate {

	func collectionView(collectionView: UICollectionView, layout: CollectionViewLeftAlignedFlowLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
}

class CollectionViewLeftAlignedFlowLayout: UICollectionViewLayout {

	var sectionInsets: UIEdgeInsets = UIEdgeInsets()
	@IBInspectable var itemSize: CGSize = CGSize(width: 50, height: 50)
	@IBInspectable var itemsSpacing: CGFloat = 0
	@IBInspectable var lineSpacing: CGFloat = 0
	@IBInspectable var topSectionInsets: CGFloat {
		get {
			return sectionInsets.top
		}
		set {
			sectionInsets.top = newValue
		}
	}

	@IBInspectable var leftSectionInsets: CGFloat {
		get {
			return sectionInsets.left
		}
		set {
			sectionInsets.left = newValue
		}
	}

	@IBInspectable var bottomSectionInsets: CGFloat {
		get {
			return sectionInsets.bottom
		}
		set {
			sectionInsets.bottom = newValue
		}
	}

	@IBInspectable var rightSectionInsets: CGFloat {
		get {
			return sectionInsets.right
		}
		set {
			sectionInsets.right = newValue
		}
	}

	private var attributesDictionary = [NSIndexPath: UICollectionViewLayoutAttributes]()
	private var contentSize = CGSizeZero

	override func prepareLayout() {
		attributesDictionary = [:]
		contentSize = CGSizeZero
		guard let collectionView = collectionView else {
			return
		}

		let sectionCount = collectionView.dataSource?.numberOfSectionsInCollectionView?(collectionView) ?? 1
		var y = CGFloat(0)
		let maxWidth = CGRectGetWidth(collectionView.frame) - sectionInsets.left - sectionInsets.right
		let rightEdge = CGRectGetWidth(collectionView.frame) - sectionInsets.right
		for section in 0..<sectionCount {
			y += sectionInsets.top
			let itemCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
			var x = sectionInsets.left
			var maxHeight = itemSize.height
			for item in 0..<itemCount {
				let indexPath = NSIndexPath(forItem: item, inSection: section)
				var size: CGSize
				if let leftAlignedFlowLayoutDelegate = collectionView.delegate as? CollectionViewDelegateLeftAlignedFlowLayout {
					size = leftAlignedFlowLayoutDelegate.collectionView(collectionView, layout: self, sizeForItemAtIndexPath: indexPath)
				} else {
					size = itemSize
				}
				size.width = min(maxWidth, size.width)
				maxHeight = max(maxHeight, size.height)
				let frame: CGRect
				if x + size.width > rightEdge {
					y +=  (lineSpacing + maxHeight)
					x = sectionInsets.left
				}
				frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
				x += itemsSpacing + size.width
				
				let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
				attributes.frame = frame
				attributesDictionary[indexPath] = attributes
			}
			y += (maxHeight + sectionInsets.bottom)
		}
		contentSize = CGSize(width: CGRectGetWidth(collectionView.frame), height: y)
	}

	override func collectionViewContentSize() -> CGSize {
		return contentSize
	}

	override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
		return attributesDictionary[indexPath]
	}

	override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var attributesArray = [UICollectionViewLayoutAttributes]()
		attributesDictionary.forEach { (element) -> () in
			if CGRectIntersectsRect(rect, element.1.frame) {
				attributesArray.append(element.1)
			}
		}
		return attributesArray
	}
}
