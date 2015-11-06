
//
//  ComposerReadDateTableViewCelll.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/2/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ComposerReadDateTableViewCellDelegate: class {

	func composerReadDateTableViewCellDidPressDeleteButton(cell: ComposerReadDateTableViewCell)
	func composerReadDateTableViewCell(cell: ComposerReadDateTableViewCell, didPickDate date: NSDate)

}

class ComposerReadDateTableViewCell: UITableViewCell {

	static let reuseIdentifier = "ComposerReadDateTableViewCell"

	private static let dateFormatter: NSDateFormatter = {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMM dd, yyyy"
		return dateFormatter
	}()

	private struct Constants {
		static let toolBarHeight = CGFloat(30)
	}

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

	private lazy var datePicker: UIDatePicker = { [unowned self] in
		let datePicker = UIDatePicker()
		datePicker.minimumDate = NSDate()
		datePicker.backgroundColor = UIColor.whiteColor()
		datePicker.datePickerMode = UIDatePickerMode.Date
		return datePicker
	}()

	private lazy var datePickerToolBar: UIToolbar = { [unowned self] in
		let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.bounds), height: Constants.toolBarHeight))
		let cancelButton = UIBarButtonItem(title: LocalizedString("Cancel"), style: .Plain, target: self, action: Selector("cancelPicking"))
		cancelButton.setTitleTextAttributes([NSForegroundColorAttributeName: AppColors.blue, NSFontAttributeName: UIFont.openSansRegular(13.0)], forState: .Normal)
		let doneButton = UIBarButtonItem(title: LocalizedString("Done"), style: .Plain, target: self, action: Selector("pickDate"))
		doneButton.setTitleTextAttributes([NSForegroundColorAttributeName: AppColors.blue, NSFontAttributeName: UIFont.openSansSemibold(13.0)], forState: .Normal)
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
		toolBar.items = [cancelButton, spaceButton, doneButton]
		return toolBar
	}()

	var date = NSDate()

    weak var delegate: ComposerReadDateTableViewCellDelegate?

	// MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = UIEdgeInsetsZero
		titleLabel.text = LocalizedString("Request Confirmation by:")
		textField.tintColor = UIColor.clearColor()
		textField.inputView = datePicker
		textField.inputAccessoryView = datePickerToolBar
		updateTextFieldText()
    }

	override func prepareForReuse() {
		super.prepareForReuse()
		updateTextFieldText()
	}

	// MARK: - Public 

	func showDatePicker() {
		textField.becomeFirstResponder()
	}

	// MARK: - Private

	private func updateTextFieldText() {
		textField.text = ComposerReadDateTableViewCell.dateFormatter.stringFromDate(date)
	}

	// MARK: - Actions

    func cancelPicking() {
        textField.resignFirstResponder()
		datePicker.date = date
    }
    
    func pickDate() {
		date = datePicker.date
		updateTextFieldText()
		textField.resignFirstResponder()
		delegate?.composerReadDateTableViewCell(self, didPickDate: date)
    }
    
    @IBAction func deleteDateAction() {
		textField.resignFirstResponder()
        delegate?.composerReadDateTableViewCellDidPressDeleteButton(self)
		datePicker.date = NSDate()
		date = datePicker.date
    }
}
