//
//  WSAccountTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSAccountTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let _ = user else { return 0 }
        return 7
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = user else { return 0 }
        switch section {
        case 0:
            // Profile image and availability
            return 2
        case 1:
            // Account details
            return 3
        case 2:
            // Feedback
            return 1
        case 3:
            // About
            return 1
        case 4:
            // Hosting info
            var count = user.hostingInfo.count
            if user.offers.count > 0 { count += 1 + user.offers.count }
            return count
        case 5:
            // Contact details
            return user.phoneNumbers.count
        case 6:
            // Address
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let user = user else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            // Profile image and availability
            switch indexPath.row {
            case 0:
                // Profile image
                let cell = tableView.dequeueReusableCellWithIdentifier(ImageCellID, forIndexPath: indexPath) as! ProfileImageTableViewCell
                cell.nameLabel.text = user.fullname
                // TODO set the photo height to 35% of the screen height
                if let photo = user.profileImage {
                    cell.nameLabel.textColor = UIColor.whiteColor()
                    cell.noImageLabel.hidden = true
                    cell.profileImage.hidden = false
                    cell.profileImage.image = photo
                    cell.profileImage.contentMode = .ScaleAspectFill
                } else {
                    cell.nameLabel.textColor = WSColor.DarkBlue
                    cell.profileImage.hidden = true
                    cell.noImageLabel.hidden = false
                }
                return cell
            case 1:
                // Availiblity
                let cell = tableView.dequeueReusableCellWithIdentifier(AvailabilityCellID, forIndexPath: indexPath) as! AvailabilityTableViewCell
                if user.notcurrentlyavailable ?? true {
                    cell.configureAsNotAvailable()
                } else {
                    cell.configureAsAvailable()
                }
                return cell
            default:
                let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
                return cell
            }
            
        case 1:
            // Account details
            switch indexPath.row {
            case 0:
                // Memeber for ...
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountDetailCellID, forIndexPath: indexPath) as! AccountDetailTableViewCell
                cell.label.text = memberForTextForUser(user)
                return cell
            case 1:
                // Active ... ago
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountDetailCellID, forIndexPath: indexPath) as! AccountDetailTableViewCell
                cell.label.text = activeAgoTextForUser(user)
                return cell
            case 2:
                // Languages spoken: ...
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountDetailCellID, forIndexPath: indexPath) as! AccountDetailTableViewCell
                cell.label.text = languagesSpokenTextForUser(user)
                return cell
            default:
                let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
                return cell
            }
            
        case 2:
            // Feedback
            let cell = tableView.dequeueReusableCellWithIdentifier(FeedbackCountCellID, forIndexPath: indexPath)
            cell.textLabel?.text = feedbackCellTextForUser(user)
            return cell
            
        case 3:
            // About
            let cell = tableView.dequeueReusableCellWithIdentifier(AboutCellID, forIndexPath: indexPath) as! AboutTableViewCell
            cell.aboutTextView.text = user.comments
            return cell
            
        case 4:
            // Hosting info
            if indexPath.row < user.hostingInfo.count {
                // Display host info
                let cell = tableView.dequeueReusableCellWithIdentifier(HostingInfoCellID, forIndexPath: indexPath) as! HostingInfoTableViewCell
                cell.titleLabel.text = hostingInfoTitleForInfoAtIndex(indexPath.row, fromUser: user)
                cell.infoLabel.text = hostingInfoDetailForInfoAtIndex(indexPath.row, fromUser: user)
                return cell
            } else if indexPath.row == user.hostingInfo.count {
                // Display "This host may offer"
                let cell = tableView.dequeueReusableCellWithIdentifier(OfferHeadingCellID, forIndexPath: indexPath)
                return cell
            } else {
                // Display an offer
                let cell = tableView.dequeueReusableCellWithIdentifier(OfferCellID, forIndexPath: indexPath) as! HostOfferTableViewCell
                cell.offerLabel.text = offerTextForOfferAtIndex(indexPath.row - 5, fromUser: user)
                return cell
            }
            
        case 5:
            // Contact details
            let cell = tableView.dequeueReusableCellWithIdentifier(ContactCellID, forIndexPath: indexPath) as! PhoneNumberTableViewCell
            cell.titleLabel.text = phoneNumberDescriptionForPhoneNumberAtIndex(indexPath.row, fromUser: user)
            cell.detailLabel.text = phoneNumberForPhoneNumberAtIndex(indexPath.row, fromUser: user)
            if let type = phoneNumberTypeForPhoneAtIndex(indexPath.row, fromUser: user) {
                switch type {
                case .Home, .Work:
                    cell.phoneIcon.hidden = false
                    cell.messageIcon.hidden = true
                case .Mobile:
                    cell.phoneIcon.hidden = false
                    cell.messageIcon.hidden = false
                }
            }
            return cell
            
        case 6:
            // Address
            let cell = tableView.dequeueReusableCellWithIdentifier(ContactCellID, forIndexPath: indexPath) as! PhoneNumberTableViewCell
            cell.titleLabel.numberOfLines = 0
            cell.titleLabel.text = "Address"
            cell.detailLabel.text = addressTextForUser(user)
            cell.phoneIcon.hidden = true
            cell.messageIcon.hidden = true
            return cell
            
        default:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            return cell
        }
        
    }
    
}