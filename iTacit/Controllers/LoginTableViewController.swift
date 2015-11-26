//
//  LoginTableViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/26/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

enum LoginType {
    case LoginTypeWithOrgCode
    case LoginTypeFirstLogin
    case LoginTypeWithPassword
}

class LoginTableViewController: UITableViewController {
    
    var loginType: LoginType = .LoginTypeFirstLogin
    
    private struct Constants {
        static let logoCellID = "LogoTableViewCell"
        static let inputCellID = "InputTableViewCell"
        static let rememberMeCellID = "RememberMeTableViewCell"
        static let signInCellID = "SignInTableViewCell"
        static let loginUserCellID = "LoginUserTableViewCell"
        static let avatarCellHeight: CGFloat = 170.0
        static let defaultCellHeight: CGFloat = 50.0
        static let signUpCellHeight: CGFloat = 57.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = Constants.defaultCellHeight
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return Constants.avatarCellHeight
        } else {
            if loginType == .LoginTypeWithOrgCode {
                if indexPath.row > 3 {
                    return Constants.signUpCellHeight
                }
                
                return UITableViewAutomaticDimension
            } else {
                if indexPath.row > 2 {
                    return Constants.signUpCellHeight
                }
                
                return UITableViewAutomaticDimension
            }
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loginType == .LoginTypeWithOrgCode {
            return 6
        }
        
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if loginType == .LoginTypeFirstLogin {
            return getCellsForDefaultLogin(indexPath)
        } else if loginType == .LoginTypeWithOrgCode {
            return getCellsForOrgCodeLogin(indexPath)
        } else {
            return getCellsForDefaultLogin(indexPath)
        }
    }
    
    private func getCellsForDefaultLogin(indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.logoCellID, forIndexPath: indexPath) as! LogoTableViewCell
            cell.cellType = CellType.CellTypeDefault
            
            return cell
        } else if indexPath.row == 1 {
            if loginType == .LoginTypeFirstLogin {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.inputCellID, forIndexPath: indexPath) as! InputTableViewCell
                cell.cellType = InputCellType.InputCellTypeName
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.loginUserCellID, forIndexPath: indexPath) as! LoginUserTableViewCell
                
                return cell
            }
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.inputCellID, forIndexPath: indexPath) as! InputTableViewCell
            cell.cellType = InputCellType.InputCellTypePassword
            
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.rememberMeCellID, forIndexPath: indexPath) as! RememberMeTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.signInCellID, forIndexPath: indexPath) as! SignInTableViewCell
            
            return cell
        }
    }
    
    private func getCellsForOrgCodeLogin(indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.logoCellID, forIndexPath: indexPath) as! LogoTableViewCell
            cell.cellType = CellType.CellTypeWithoutLabel
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.inputCellID, forIndexPath: indexPath) as! InputTableViewCell
            cell.cellType = InputCellType.InputCellTypeOrgCode
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.inputCellID, forIndexPath: indexPath) as! InputTableViewCell
            cell.cellType = InputCellType.InputCellTypeName
            
            return cell
        } else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.inputCellID, forIndexPath: indexPath) as! InputTableViewCell
            cell.cellType = InputCellType.InputCellTypePassword
            
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.rememberMeCellID, forIndexPath: indexPath) as! RememberMeTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.signInCellID, forIndexPath: indexPath) as! SignInTableViewCell
            
            return cell
        }
    }

}
