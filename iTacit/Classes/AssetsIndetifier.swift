//
//  AssetsIndetifier.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

enum AssetsIndetifier: String {

	case BackBatton = "btn_back"
	case TrianglePointerUp = "btn_drop_show"
	case TrianglePointerDown = "btn_drop_hide"

}

extension UIImage {

	convenience init(assetsIndetifier: AssetsIndetifier) {
		self.init(named: assetsIndetifier.rawValue)!
	}

}