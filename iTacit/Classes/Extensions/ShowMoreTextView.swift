//
//  ShowMoreTextView.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/16/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ShowMoreTextViewDelegate: class {
    func needsToReloadTableView();
}

@IBDesignable

class ShowMoreTextView: UITextView {
    
    weak var showMoreDelegate: ShowMoreTextViewDelegate?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        scrollEnabled = false
        editable = false
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    convenience init() {
        self.init(frame: CGRectZero, textContainer: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollEnabled = false
        editable = false
    }
    
    convenience init(maximumNumberOfLines: Int, trimText: NSString?, shouldTrim: Bool) {
        self.init()
        self.maximumNumberOfLines = maximumNumberOfLines
        self.trimText = trimText
        self.shouldTrim = shouldTrim
    }
    
    convenience init(maximumNumberOfLines: Int, attributedTrimText: NSAttributedString?, shouldTrim: Bool) {
        self.init()
        self.maximumNumberOfLines = maximumNumberOfLines
        self.attributedTrimText = attributedTrimText
        self.shouldTrim = shouldTrim
    }
    @IBInspectable
    var maximumNumberOfLines: Int = 2 {
        didSet {
            setNeedsLayout()
        }
    }
    var trimText: NSString? {
        didSet {
            setNeedsLayout()
        }
    }
    var attributedTrimText: NSAttributedString? {
        didSet {
            setNeedsLayout()
        }
    }
    var shouldTrim: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    var trimTextRangePadding: UIEdgeInsets = UIEdgeInsetsZero
    private var originalAttributedText: NSAttributedString!
    private var originalText: String!
    
    override var text: String! {
        didSet {
            originalText = text
            originalAttributedText = nil
            if needsTrim() { updateText() }
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            originalAttributedText = attributedText
            originalText = nil
            if needsTrim() { updateText() }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        needsTrim() ? updateText() : resetText()
    }
    
    func needsTrim() -> Bool {
        return shouldTrim && _trimText != nil
    }
    
    func updateText() {
        textContainer.maximumNumberOfLines = maximumNumberOfLines
        textContainer.size = CGSizeMake(bounds.size.width, CGFloat.max)
        
        let range = rangeToReplaceWithTrimText()
        if range.location != NSNotFound {            
            if let text = trimText?.mutableCopy() as? NSMutableString {
                textStorage.replaceCharactersInRange(range, withString: text as String)
            } else if let text = attributedTrimText?.mutableCopy() as? NSMutableAttributedString {
                text.addAttribute(NSForegroundColorAttributeName, value: AppColors.blue, range: NSMakeRange(0, text.length))
                textStorage.replaceCharactersInRange(range, withAttributedString: text)
            }
        }
        
        invalidateIntrinsicContentSize()
    }
    
    func resetText() {
        let beforeNumberOfLines = textContainer.maximumNumberOfLines
        textContainer.maximumNumberOfLines = 0
        if originalText != nil {
            textStorage.replaceCharactersInRange(NSMakeRange(0, text.characters.count), withString: originalText)
        } else if originalAttributedText != nil {
            textStorage.replaceCharactersInRange(NSMakeRange(0, text.characters.count), withAttributedString: originalAttributedText)
        }
        
        invalidateIntrinsicContentSize()
        
        if beforeNumberOfLines != 0 {
            showMoreDelegate?.needsToReloadTableView()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        textContainer.size = CGSizeMake(bounds.size.width, CGFloat.max)
        var intrinsicContentSize = layoutManager.boundingRectForGlyphRange(layoutManager.glyphRangeForTextContainer(textContainer), inTextContainer: textContainer).size
        intrinsicContentSize.width = UIViewNoIntrinsicMetric
        intrinsicContentSize.height += (textContainerInset.top + textContainerInset.bottom)
        
        return intrinsicContentSize
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if needsTrim() && pointInTrimTextRange(point) {
            shouldTrim = false
            maximumNumberOfLines = 0
        }
        
        return super.hitTest(point, withEvent: event)
    }
    
    //MARK: Private methods
    
    private var _trimText: NSString? {
        get {
            return trimText ?? attributedTrimText?.string
        }
    }
    
    private var _originalTextLength: Int {
        get {
            if originalText != nil {
                return originalText!.characters.count
            } else  if originalAttributedText != nil {
                return originalAttributedText!.length
            }
            
            return 0
        }
    }
    
    private func rangeToReplaceWithTrimText() -> NSRange {
        let emptyRange = NSMakeRange(NSNotFound, 0)
        
        var rangeToReplace = layoutManager.characterRangeThatFits(textContainer)
        if NSMaxRange(rangeToReplace) == _originalTextLength {
            rangeToReplace = emptyRange
        } else {
            rangeToReplace.location = NSMaxRange(rangeToReplace) - _trimText!.length
            if rangeToReplace.location < 0 {
                rangeToReplace = emptyRange
            } else {
                rangeToReplace.length = textStorage.length - rangeToReplace.location
            }
        }
        
        return rangeToReplace
    }
    
    private func trimTextRange() -> NSRange {
        var trimTextRange = rangeToReplaceWithTrimText()
        if trimTextRange.location != NSNotFound {
            trimTextRange.length = _trimText!.length
        }
        
        return trimTextRange
    }
    
    private func pointInTrimTextRange(point: CGPoint) -> Bool {
        let offset = CGPointMake(textContainerInset.left, textContainerInset.top)
        var boundingRect = layoutManager.boundingRectForCharacterRange(trimTextRange(), inTextContainer: textContainer, textContainerOffset: offset)
        boundingRect = CGRectOffset(boundingRect, textContainerInset.left, textContainerInset.top)
        boundingRect = CGRectInset(boundingRect, -(trimTextRangePadding.left + trimTextRangePadding.right), -(trimTextRangePadding.top + trimTextRangePadding.bottom))
        
        return CGRectContainsPoint(boundingRect, point)
    }
    
}

//MARK: NSLayoutManager

extension NSLayoutManager {
    
    func characterRangeThatFits(textContainer: NSTextContainer) -> NSRange {
        var rangeThatFits = self.glyphRangeForTextContainer(textContainer)
        rangeThatFits = self.characterRangeForGlyphRange(rangeThatFits, actualGlyphRange: nil)
        
        return rangeThatFits
    }
    
    func boundingRectForCharacterRange(range: NSRange, inTextContainer textContainer: NSTextContainer, textContainerOffset: CGPoint) -> CGRect {
        let glyphRange = self.glyphRangeForCharacterRange(range, actualCharacterRange: nil)
        let boundingRect = self.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer)
        
        return boundingRect
    }
    
}
