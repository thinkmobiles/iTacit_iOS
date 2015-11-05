//
//  DatePickerTableViewCell.swift
//  iTacit
//
//  Created by Sergey Sheba on 10/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol DatePickerCellDelegate {
	
    func didPressCancelButton()
    func didPressDoneButtonWithDate(date: NSDate)
}

class DatePickerTableViewCell: UITableViewCell {
    
    var delegate: DatePickerCellDelegate?

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelButton.setTitle(LocalizedString("CANCEL"), forState: .Normal)
        doneButton.setTitle(LocalizedString("DONE"), forState: .Normal)
    }

    // MARK: - IBAction
    
    @IBAction func camcelButtonAction(sender: UIButton) {
        delegate?.didPressCancelButton()
    }
    
    @IBAction func doneButtonAction(sender: UIButton) {
        delegate?.didPressDoneButtonWithDate(datePicker.date)
    }
}
