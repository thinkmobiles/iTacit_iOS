//
//  LocalizationService.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/29/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation
import UIKit

class LocalizationService {
    
    private struct LanguageKey {
        static let DefaultLangugeKey = "DefaultLangugeKey"
    }
    
    enum Language: String {
        case English = "en-GB"
        case French = "fr-FR"
    }
    
    private static var _language: Language = {
        
        if let languageRawValue = NSUserDefaults.standardUserDefaults().valueForKey(LanguageKey.DefaultLangugeKey) as? String {
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
            NSUserDefaults.standardUserDefaults().setValue(newValue.rawValue, forKey: LanguageKey.DefaultLangugeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static func setDefaulLanguage(defaulLanguage: Language) {
        language = defaulLanguage
    }
    
    static let bundles: [Language : NSBundle] = {
        let enLanguage = NSBundle(path: NSBundle.mainBundle().pathForResource("en", ofType: "lproj")!)
        let frLanguage = NSBundle(path: NSBundle.mainBundle().pathForResource("fr", ofType: "lproj")!)
        
        return [Language.English: enLanguage!, Language.French : frLanguage!]
    }()
    
    static func LocalizedString(key :String) -> String {
        return bundles[language]?.localizedStringForKey(key, value: "", table: nil) ?? key
    }
}