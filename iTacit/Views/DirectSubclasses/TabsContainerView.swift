//
//  TabsContainerView.swift
//  TabBarController
//
//  Created by Sauron Black on 10/13/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import UIKit

class TabsContainerView: UIView {

	override func drawRect(rect: CGRect) {
        let bezierPath = UIBezierPath()
		bezierPath.moveToPoint(CGPointZero)
		bezierPath.addLineToPoint(CGPoint(x: CGRectGetWidth(bounds), y: 0))
		bezierPath.lineWidth = 0.5
		AppColors.lightGray.setStroke()
		bezierPath.stroke()
    }

}
