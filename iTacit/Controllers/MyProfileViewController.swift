//
//  MyProfileViewController.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/23/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MyProfileViewController: UITableViewController, UINavigationControllerDelegate {
    
    private struct Constants {
        static let mainBlockHeight: CGFloat = 433
        static let cellHeight: CGFloat = 44
        static let minFooterHeight: CGFloat = 80
        static let sectionHeaderHeight: CGFloat = 35
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var phoneSwitch: UISwitch!
    @IBOutlet weak var userSmallImage: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    var userProfile = UserProfileModel()
    var imageDownloadTask: NSURLSessionTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        userProfile = SharedStorage.sharedInstance.userProfile ?? UserProfileModel()
        prepareFooterView()
        addBackButton()
		updateUI()
    }

    func addBackButton() {
        let backBarButton = UIBarButtonItem(image: UIImage(assetsIndetifier: .BackButton), style: .Plain, target: self, action: Selector("backButtonAction"))
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    func backButtonAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }

		let headerView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), Constants.sectionHeaderHeight))
		let offset = CGFloat(6)
        let customLabel = UILabel(frame: CGRectMake(offset, 0, CGRectGetWidth(tableView.bounds) - offset, Constants.sectionHeaderHeight))
        customLabel.text = LocalizedString("RECEIVE NOTIFICATIONS")
        customLabel.font = UIFont.openSansRegular(10)
        customLabel.textColor = UIColor(hexColor: 0x3B3B3B)
		headerView.addSubview(customLabel)
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        
        return Constants.sectionHeaderHeight
    }
    
    @IBAction func changeImageAction(sender: UIButton) {
        let alertController = UIAlertController(title: LocalizedString("Change Picture"), message: LocalizedString("What do you want to do?"), preferredStyle: .ActionSheet)
        
        let defaultAction = UIAlertAction(title: LocalizedString("Cancel"), style: .Default, handler: nil)
        let uploadAction = UIAlertAction(title: LocalizedString("Upload from Camera Roll"), style: .Default, handler: { [unowned self] (action) -> Void in
            self.showImagePicker()
        })
    
        alertController.addAction(uploadAction)
        alertController.addAction(defaultAction)

        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOutAction(sender: UIButton) {
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
    }
    
    @IBAction func mailSwitchDidChange(sender: AnyObject) {
    }
    
    @IBAction func phoneSwitchDidChange(sender: UISwitch) {
    }
    
    // MARK: - Private
    
    func prepareFooterView() {
        let diff = UIScreen.mainScreen().bounds.height - Constants.mainBlockHeight
        let height: CGFloat = (diff < Constants.minFooterHeight) ? Constants.minFooterHeight : diff
        tableView.tableFooterView?.frame = CGRectMake(0, 0, tableView.bounds.size.width, height)
    }
    
    private func showImagePicker() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    private func updateUI() {
        userFullNameLabel.text = userProfile.fullName
        userDescriptionLabel.text = userProfile.role
        emailTextField.text = userProfile.emailAddress
        phoneTextField.text = userProfile.mobilePhoneNumber
        
        setUserImageWithURL(userProfile.imageURL)
    }
    
    private func setUserImageWithURL(imageURL: NSURL?) {
        imageDownloadTask?.cancel()
        if let imageURL = imageURL {
            imageDownloadTask = ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { [weak self] (image) -> Void in
                self?.userImageView.image = image
                self?.userSmallImage.image = image
                })
        } else {
            userImageView.image = nil
            userSmallImage.image = nil
        }
    }
    
}

extension MyProfileViewController: UIImagePickerControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userSmallImage.image = pickedImage
            userImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
