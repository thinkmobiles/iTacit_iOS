//
//  MessageDetailCommentTableViewCell.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/13/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol MessageDetailCellDelegate: class {

    func didSelectExpandButton()

}

class MessageDetailCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var credentialLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var securityImage: UIImageView!
    @IBOutlet weak var repliedViaImage: UIImageView!
    @IBOutlet weak var repliedViaLabel: UILabel!
    @IBOutlet weak var bodyTextView: ShowMoreTextView!
    @IBOutlet weak var securityImageWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: MessageDetailCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        bodyTextView.showMoreDelegate = self
        backgroundColor = AppColors.dirtyWhite
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var imageDownloadTask: NSURLSessionTask?
    var model: ReplyModel?
    
    // MARK: - IBAction
    
    @IBAction func replyButtonAction(sender: UIButton) {
    }
    
    // MARK: - Public
    
    func configureWithReplyModel(reply: ReplyModel) {
        model = reply
        
        bodyTextView.scrollEnabled = false
        bodyTextView.maximumNumberOfLines = 2
        bodyTextView.shouldTrim = true
        bodyTextView.attributedTrimText = NSMutableAttributedString(string: "...")
        
        if let sender = reply.sender {
            setUserImageWithURL(sender.imageURL)
            credentialLabel.text = sender.fullName
            replyButton.setTitle(" to \(sender.firstName)", forState: .Normal)
            descriptionLabel.text = sender.role
        }
        if let body = reply.body {
            let trimmedBodyString = body.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let mutableBody = body.mutableCopy()
            
            mutableBody.mutableString.setString(trimmedBodyString)
            bodyTextView.attributedText = mutableBody as! NSAttributedString
        }

        timeAgoLabel.text = reply.sendDateTime?.timeAgoStringRepresentation()
        confirmImage.image = reply.readConfirmed ? UIImage(assetsIndetifier: .ConfirmedIcon) :  nil
        
        //TODO: add phone icon below
        repliedViaImage.image = reply.replyMethodEmail ? UIImage(assetsIndetifier: .MailIcon) : UIImage(assetsIndetifier: .PhoneIcone)
        securityImage.image = reply.replyPrivate ? UIImage(assetsIndetifier: .PrivateIcon) : nil
        securityImageWidthConstraint.constant = reply.replyPrivate ? securityImageWidthConstraint.constant : 0
    }
    
    // MARK: - Private
    
    func setUserImageWithURL(imageURL: NSURL?) {
        imageDownloadTask?.cancel()
        if let imageURL = imageURL {
            imageDownloadTask = ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { [weak self] (image) -> Void in
                self?.userImage.image = image
                })
        } else {
            userImage.image = nil
        }
    }
}

extension MessageDetailCommentTableViewCell: ShowMoreTextViewDelegate {
    func needsToReloadTableView() {
        delegate?.didSelectExpandButton()
    }
}
