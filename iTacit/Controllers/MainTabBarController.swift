//
//  MainTabBarController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/29/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MainTabBarController: TabBarController {

    @IBOutlet weak var dashboardTabBarButton: TabBarButton!
    @IBOutlet weak var newsTabBarButton: TabBarButton!
    @IBOutlet weak var messagesTabBarButton: TabBarButton!
    @IBOutlet weak var TrainingTabBarButton: TabBarButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		BaseModel.token = TokenModel()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        LocalizationService.setDefaulLanguage(LocalizationService.Language.English)
        
        dashboardTabBarButton.title = LocalizationService.LocalizedString("Dashboard")
        newsTabBarButton.title = LocalizationService.LocalizedString("News")
        messagesTabBarButton.title = LocalizationService.LocalizedString("Messages")
        TrainingTabBarButton.title = LocalizationService.LocalizedString("Training")
    }

	func login() {
		let token = TokenModel()
		token.signInWithUsername("ph", password: "ph") { (success) -> Void in
			print("Success: \(success ? "Ja": "Nein") \n\(token)")
			if success {
				BaseModel.token = token
			}
		}
	}
} 