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
}

extension UIImage {

	convenience init(assetsIndetifier: AssetsIndetifier) {
		self.init(named: assetsIndetifier.rawValue)!
	}

}