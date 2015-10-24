//
//  ExtendedTextField.swift
//  TagsSearchControl
//
//  Created by Sauron Black on 10/24/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ExtendedTextFieldDelegate: UITextFieldDelegate {

	func didPressBackspaceInTextField(textField: ExtendedTextField)
}

class ExtendedTextField: UITextField {

	override func deleteBackward() {
		super.deleteBackward()
		if let extendedTextFieldDelegate = delegate as? ExtendedTextFieldDelegate {
			extendedTextFieldDelegate.didPressBackspaceInTextField(self)
		}
	}

}
