//
//  InputTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/26/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

enum InputCellType {
    case InputCellTypeOrgCode
    case InputCellTypeName
    case InputCellTypePassword
}

class InputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var cellType: InputCellType = InputCellType.InputCellTypeName {
        didSet {
            prepareUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private
    
    private func prepareUI() {
        switch cellType {
        case .InputCellTypeName:
            cellImage.image = UIImage(assetsIndetifier: .ConfirmedIcon)
            textField.placeholder = LocalizedString("User Name")
            textField.secureTextEntry = false
        case .InputCellTypePassword:
            cellImage.image = UIImage(assetsIndetifier: .PrivateIcon)
            textField.placeholder = LocalizedString("Password")
            textField.secureTextEntry = true
        case .InputCellTypeOrgCode:
            cellImage.image = UIImage(assetsIndetifier: .HomeIcone)
            textField.placeholder = LocalizedString("Organization Code")
            textField.secureTextEntry = false
        }
    }

}
