//
//  MessageComposerFloatingView.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/2/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessageComposerFloatingView: UIView {
    
    private struct Constants {
        static let viewHeight = 40.0
    }
    
    override func layoutSubviews() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.BottomLeft], cornerRadii: CGSize(width: Constants.viewHeight/2, height: Constants.viewHeight/2)).CGPath
        
        layer.mask = maskLayer
    }
}
