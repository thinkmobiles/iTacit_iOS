//
//  ListHeaderView.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/21/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol ListHeaderViewDelegate {
    func didSelectHeaderWithSection(headerView: UIView)
    func didSelectHeaderWithSection(headerView: UIView, button: UIButton)

}

class ListHeaderView: UIView {
    
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var numberOfCellsLabel: UILabel!
    @IBOutlet weak var disclosureImageView: UIImageView!
    
    var delegate: ListHeaderViewDelegate?
    
    var section: Int? {
        didSet {
            headerTitleLabel.text = section == 0 ? "Author: " : "Category: "
        }
    }
    
    var isExpanded: Bool? {
        didSet {
            if isExpanded == true {
                disclosureImageView.image = UIImage(named: "btn_drop_show")
            } else  {
                disclosureImageView.image = UIImage(named: "btn_drop_hide")
            }
        }
    }

    private struct Constants {
        static let NibName = "ListHeaderView"
    }

    @IBAction func expandButtonAction(sender: UIButton) {
        delegate?.didSelectHeaderWithSection(self)
    }
    
    // MARK: -  Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    // MARK: - Private
    
    func loadViewFromNib() {
        if let view = NSBundle.mainBundle().loadNibNamed(Constants.NibName, owner: self, options: nil).first as? UIView {
            self.addSubview(view)
        }
    }
}
