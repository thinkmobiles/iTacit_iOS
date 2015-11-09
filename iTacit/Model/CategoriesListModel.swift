//
//  CategoriesListModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class CategoriesListModel<T: NewsCategoryModel>: ListModel<T> {
    
    override var path: String {
        return "/mobile/1.0/news/category"
    }
    
    required init() {
        super.init()
    }
}
