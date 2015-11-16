//
//  SeparatorView.swift
//  iTacit
//
//  Created by Sauron Black on 11/13/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

@IBDesignable
class SeparatorView: UIView {

	@IBInspectable var color: UIColor = AppColors.lightGray

    override func drawRect(rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		CGContextSaveGState(context)
		CGContextSetStrokeColorWithColor(context, color.CGColor)
		CGContextSetLineWidth(context, 0.5)
		CGContextMoveToPoint(context, 0, 0)
		CGContextAddLineToPoint(context, CGRectGetWidth(bounds), 0)
		CGContextStrokePath(context)
		CGContextRestoreGState(context)
	}

}
