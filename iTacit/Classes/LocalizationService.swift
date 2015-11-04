//
//  LocalizationService.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/29/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class LocalizationService {
    
    private struct Constants {
        static let langugeKey = "DefaultLanguageKey"
    }
    
    enum Language: String {
        case English = "en-GB"
        case French = "fr-FR"
    }
    
    private static var _language: Language = {
        if let languageRawValue = NSUserDefaults.standardUserDefaults().valueForKey(Constants.langugeKey) as? String {
            return Language(rawValue: languageRawValue) ?? .English
        } else {
            return Language.English
        }
    }()
    
    class var language: Language {
        get {
            return _language
        }
        set {
            _language = newValue
            NSUserDefaults.standardUserDefaults().setValue(newValue.rawValue, forKey: Constants.langugeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static let bundles: [Language: NSBundle] = {
        let enLanguage = NSBundle(path: NSBundle.mainBundle().pathForResource("en", ofType: "lproj")!)
        let frLanguage = NSBundle(path: NSBundle.mainBundle().pathForResource("fr", ofType: "lproj")!)
        
        return [Language.English: enLanguage!, Language.French : frLanguage!]
    }()
}

func LocalizedString(key: String) -> String {
	return LocalizationService.bundles[LocalizationService.language]?.localizedStringForKey(key, value: "", table: nil) ?? key
}