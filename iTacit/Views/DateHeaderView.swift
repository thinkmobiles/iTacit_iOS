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
    
    var setStartDateButtonLabel: String {
        get {
            return (addStartDateButton.titleLabel?.text)!
        }
        set {
            addStartDateButton.titleLabel?.text = newValue
            setButtonAppearenceToSelected(addStartDateButton, isSelected: true)
        }
    }
    
    var setEndDateButtonLabel: String {
        get {
            return (addEndDateButton.titleLabel?.text)!
        }
        set {
            addEndDateButton.titleLabel?.text = newValue
            setButtonAppearenceToSelected(addEndDateButton, isSelected: true)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func expandButtonAction(sender: UIButton) {
    }
    
    @IBAction func addStartDateButtonAction(sender: UIButton) {
        if addStartDateButton.titleLabel?.text == Constants.ButtonText {
            delegate?.didSelectHeaderWithSection(self)
        }
    }
    
    @IBAction func addEndDateButtonAction(sender: UIButton) {
    }
    
    // MARK: - Global
    
    func setButtonsTodefaultCondition() {
        
    }
    
    // MARK: - Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromXib()
        setButtonAppearenceToSelected(addStartDateButton, isSelected: false)
        setButtonAppearenceToSelected(addEndDateButton, isSelected: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromXib()
        setButtonAppearenceToSelected(addStartDateButton, isSelected: false)
        setButtonAppearenceToSelected(addEndDateButton, isSelected: false)
    }

    // MARK: - Private
    
    func setButtonAppearenceToSelected(button: UIButton, isSelected:Bool) {
        if isSelected {
           // TODO: add apearence for selected state
        } else {
            button.layer.cornerRadius = CGRectGetMaxY(addStartDateButton.bounds) / 2
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            button.titleLabel?.text = Constants.ButtonText
            button.tintColor = UIColor.grayColor()
        }
    }
    
    func loadViewFromXib() {
        if let view = NSBundle.mainBundle().loadNibNamed(Constants.NibName, owner: self, options: nil).first as? UIView {
            view.frame = self.frame
            self.addSubview(view)
        }
    }
}
