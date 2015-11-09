//
//  AssetsIndetifier.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

enum AssetsIndetifier: String {

	case BackButton = "btn_back"
	case TrianglePointerUp = "ic_drop_up"
	case TrianglePointerDown = "ic_drop_down"

}

extension UIImage {

	convenience init(assetsIndetifier: AssetsIndetifier) {
		self.init(named: assetsIndetifier.rawValue)!
	}

}