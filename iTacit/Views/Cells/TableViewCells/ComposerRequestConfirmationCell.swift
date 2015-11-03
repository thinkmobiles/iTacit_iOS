
//
//  ComposerRequestConfirmationCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/2/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ConfirmationCellDelegate {
    func confirmationCellCancelButtonPressed()
    func pickeDate(date: NSDate)
}

class ComposerRequestConfirmationCell: UITableViewCell {

    @IBOutlet weak var cellTitileLabel: UILabel!
    @IBOutlet weak var cancelButtonAction: NSLayoutConstraint!
    @IBOutlet weak var pickedDateTextField: UITextField!
    
    private var pickedDate: NSDate?
    
    var delegate: ConfirmationCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.minimumDate = NSDate()
        datePickerView.backgroundColor = UIColor.whiteColor()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        pickedDateTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "keyboardCancelButtonTapped"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "keyboardDoneButtonTapped")]
        
        numberToolbar.sizeToFit()
        pickedDateTextField.inputAccessoryView = numberToolbar
        
        cellTitileLabel.text = "Request Confirmation by:"
        pickedDateTextField.tintColor = UIColor.clearColor()
    }

    func keyboardCancelButtonTapped() {
        endEditing(true)
    }
    
    func keyboardDoneButtonTapped() {
        if let date = pickedDate {
            delegate?.pickeDate(date)
            endEditing(true)
        } else {
            keyboardCancelButtonTapped()
        }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        pickedDateTextField.text = dateFormatter.stringFromDate(sender.date)
        layoutIfNeeded()
        pickedDate = sender.date
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        delegate?.confirmationCellCancelButtonPressed()
    }
}

extension ComposerRequestConfirmationCell: UITextFieldDelegate {
}
