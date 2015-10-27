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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - IBAction
    
    @IBAction func camcelButtonAction(sender: UIButton) {
        delegate?.didPressCancelButton()
    }
    
    @IBAction func doneButtonAction(sender: UIButton) {
        delegate?.didPressDoneButtonWithDate(datePicker.date)
    }
}
