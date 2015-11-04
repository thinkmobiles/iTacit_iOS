//
//  Extensions.swift
//  Sensei
//
//  Created by Sauron Black on 6/8/15.
//  Copyright (c) 2015 iTacit. All rights reserved.
//

import UIKit

// MARK: - UIView

extension UIView {
    
    func addEdgePinnedSubview(view: UIView) {
        view.frame = bounds
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0.0-[view]-0.0-|", options: NSLayoutFormatOptions(), metrics: nil, views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0.0-[view]-0.0-|", options: NSLayoutFormatOptions(), metrics: nil, views: bindings))
    }
}

// MARK: - UIColor+Hex

extension UIColor {
    
    convenience init(hexColor: Int, alpha: CGFloat) {
        let red: CGFloat = CGFloat((hexColor >> 16) & 0xff) / 255.0
        let green: CGFloat = CGFloat((hexColor >> 8) & 0xff) / 255.0
        let blue: CGFloat = CGFloat(hexColor & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(hexColor: Int) {
        self.init(hexColor: hexColor, alpha: 1.0)
    }
}

// MARK: - Dictionary

func + <K,V>(left: [K:V], right: [K:V]) -> [K:V] {
    var map = [K:V]()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}

// MARK: - String

extension String {

	func rangeFromNSRange(nsRange: NSRange) -> Range<String.Index>? {
		let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
		if let from = String.Index(from16, within: self),
			let to = String.Index(from16.advancedBy(nsRange.length, limit: utf16.endIndex), within: self) {
				return from ..< to
		}
		return nil
	}

	var isEmptyOrWhitespaces: Bool {
		if isEmpty {
			return true
		}

		return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty
	}

	func beginsWithString(substring: String) -> Bool {
		if let range = rangeOfString(substring, options: .CaseInsensitiveSearch) where range.startIndex == startIndex {
			return true
		}
		return false
	}
}
