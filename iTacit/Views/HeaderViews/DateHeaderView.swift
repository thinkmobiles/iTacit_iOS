 //
//  DateHeaderView.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/21/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class DateHeaderView: UIView {

    private struct Constants {
        static let NibName = "DateHeaderView"
        static let ButtonText = "Add Date"
    }
    
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addStartDateButton: UIButton!
    @IBOutlet weak var addEndDateButton: UIButton!
    
    var delegate: ListHeaderViewDelegate?
    var section: Int?
    
    var searchNewsModel: SearchNewsModel? {
        didSet {
            
            if let startDate = searchNewsModel?.startDate {
                setButtonAppearenceToSelected(addStartDateButton, isSelected: true, buttonTitle: getStringRepresentation(startDate))
            } else {
                setButtonAppearenceToSelected(addStartDateButton, isSelected: false, buttonTitle: Constants.ButtonText)
            }
            if let endDate = searchNewsModel?.endDate {
                setButtonAppearenceToSelected(addEndDateButton, isSelected: true, buttonTitle: getStringRepresentation(endDate))
            } else {
                setButtonAppearenceToSelected(addEndDateButton, isSelected: false, buttonTitle: Constants.ButtonText)
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func expandButtonAction(sender: UIButton) {
    }
    
    @IBAction func addStartDateButtonAction(sender: UIButton) {
        delegate?.didSelectHeaderWithSection(self, button: addStartDateButton)
    }
    
    @IBAction func addEndDateButtonAction(sender: UIButton) {
        delegate?.didSelectHeaderWithSection(self, button: addEndDateButton)
    }
    
    // MARK: - Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromXib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.text = LocalizationService.LocalizedString("Date") + ": " + LocalizationService.LocalizedString("Change Date")
    }
    
    // MARK: - Private
    
    func setButtonAppearenceToSelected(button: UIButton, isSelected:Bool, buttonTitle: String) {
        button.layer.cornerRadius = CGRectGetMaxY(addStartDateButton.bounds) / 2
        button.layer.borderWidth = 1.0
        
        if isSelected == true {
            button.setTitle(buttonTitle, forState: .Normal)
            button.layer.borderColor = AppColors.blue.CGColor
            button.setTitleColor(AppColors.blue, forState: UIControlState.Normal)
        } else {
            button.layer.borderColor = AppColors.lightGrayButtonBorder.CGColor
            button.tintColor = UIColor.grayColor()
            button.setTitleColor(AppColors.grayButtonFont, forState: UIControlState.Normal)
        }
    }
    
    func loadViewFromXib() {
        if let view = NSBundle.mainBundle().loadNibNamed(Constants.NibName, owner: self, options: nil).first as? UIView {
            view.frame = self.frame
            self.addSubview(view)
        }
        
        addStartDateButton.setTitle(LocalizationService.LocalizedString("Add Date"), forState: .Normal)
        addEndDateButton.setTitle(LocalizationService.LocalizedString("Add Date"), forState: .Normal)
    }
    
    private func getStringRepresentation(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy"
        
        return dateFormatter.stringFromDate(date)
    }
}
