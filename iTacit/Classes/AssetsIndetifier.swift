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
	case SelectedIcon = "check_filter_act"
	case UnselectedIcon = "check_filter"
	case CloseIcon = "btn_close"
    case ConfirmedIcon = "ic_user_compl"
}

extension UIImage {

	convenience init(assetsIndetifier: AssetsIndetifier) {
		self.init(named: assetsIndetifier.rawValue)!
	}

}