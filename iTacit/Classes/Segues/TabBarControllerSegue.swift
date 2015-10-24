//
//  TabBarControllerSegue.swift
//  TabBarController
//
//  Created by Sauron Black on 10/14/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class TabBarControllerSegue: UIStoryboardSegue {

	override func perform() {
		assert(sourceViewController is TabBarController, "Source view controller must be instance of TabBarController or its subclass")
		(sourceViewController as! TabBarController).viewControllers.append(destinationViewController)
	}

}
