//
//  BannerListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/26/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class BannerListModel<T: BannerModel>: PageListModel<T> {

	override var path: String {
		return "/mobile/1.0/system/banner"
	}

	required init() {
		super.init()
	}

}
