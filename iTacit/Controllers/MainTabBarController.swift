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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let model: SingleNewsModels = SingleNewsModels()

        LocalizationService.setDefaulLanguage(LocalizationService.Language.English)
        
        dashboardTabBarButton.title = LocalizationService.LocalizedString("Dashboard")
        newsTabBarButton.title = LocalizationService.LocalizedString("News")
        messagesTabBarButton.title = LocalizationService.LocalizedString("Messages")
        TrainingTabBarButton.title = LocalizationService.LocalizedString("Training")
    }
} 