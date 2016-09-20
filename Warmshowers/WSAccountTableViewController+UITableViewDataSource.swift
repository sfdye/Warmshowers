//
//  WSAccountTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSAccountTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = user else { return 0 }
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = user else { return UITableViewCell() }
        switch (indexPath as NSIndexPath).section {
        case 0:
            // Profile image and availability
            switch (indexPath as NSIndexPath).row {
            case 0:
                // Profile image
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageCellID, for: indexPath) as! ProfileImageTableViewCell
                cell.nameLabel.text = user.fullname
                // TODO set the photo height to 35% of the screen height
                if let photo = user.profileImage {
                    cell.nameLabel.textColor = UIColor.white
                    cell.noImageLabel.isHidden = true
                    cell.profileImage.isHidden = false
                    cell.profileImage.image = photo
                    cell.profileImage.contentMode = .scaleAspectFill
                } else {
                    cell.nameLabel.textColor = WSColor.DarkBlue
                    cell.profileImage.isHidden = true
                    cell.noImageLabel.isHidden = false
                }
                return cell
            case 1:
                // Availiblity
                let cell = tableView.dequeueReusableCell(withIdentifier: AvailabilityCellID, for: indexPath) as! AvailabilityTableViewCell
                if user.notcurrentlyavailable ?? true {
                    cell.configureAsNotAvailable()
                } else {
                    cell.configureAsAvailable()
                }
                return cell
            default:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                return cell
            }
            
        case 1:
            // Account details
            switch (indexPath as NSIndexPath).row {
            case 0:
                // Memeber for ...
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailCellID, for: indexPath) as! AccountDetailTableViewCell
                cell.label.text = memberForTextForUser(user)
                return cell
            case 1:
                // Active ... ago
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailCellID, for: indexPath) as! AccountDetailTableViewCell
                cell.label.text = activeAgoTextForUser(user)
                return cell
            case 2:
                // Languages spoken: ...
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailCellID, for: indexPath) as! AccountDetailTableViewCell
                cell.label.text = languagesSpokenTextForUser(user)
                return cell
            default:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                return cell
            }
            
        case 2:
            // Feedback
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackCountCellID, for: indexPath)
            cell.textLabel?.text = feedbackCellTextForUser(user)
            return cell
            
        case 3:
            // About
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutCellID, for: indexPath) as! AboutTableViewCell
            cell.aboutTextView.text = user.comments
            return cell
            
        case 4:
            // Hosting info
            if (indexPath as NSIndexPath).row < user.hostingInfo.count {
                // Display host info
                let cell = tableView.dequeueReusableCell(withIdentifier: HostingInfoCellID, for: indexPath) as! HostingInfoTableViewCell
                cell.titleLabel.text = hostingInfoTitleForInfoAtIndex((indexPath as NSIndexPath).row, fromUser: user)
                cell.infoLabel.text = hostingInfoDetailForInfoAtIndex((indexPath as NSIndexPath).row, fromUser: user)
                return cell
            } else if (indexPath as NSIndexPath).row == user.hostingInfo.count {
                // Display "This host may offer"
                let cell = tableView.dequeueReusableCell(withIdentifier: OfferHeadingCellID, for: indexPath)
                return cell
            } else {
                // Display an offer
                let cell = tableView.dequeueReusableCell(withIdentifier: OfferCellID, for: indexPath) as! HostOfferTableViewCell
                cell.offerLabel.text = offerTextForOfferAtIndex((indexPath as NSIndexPath).row - 5, fromUser: user)
                return cell
            }
            
        case 5:
            // Contact details
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactCellID, for: indexPath) as! PhoneNumberTableViewCell
            cell.titleLabel.text = phoneNumberDescriptionForPhoneNumberAtIndex((indexPath as NSIndexPath).row, fromUser: user)
            cell.detailLabel.text = phoneNumberForPhoneNumberAtIndex((indexPath as NSIndexPath).row, fromUser: user)
            if let type = phoneNumberTypeForPhoneAtIndex((indexPath as NSIndexPath).row, fromUser: user) {
                switch type {
                case .home, .work:
                    cell.phoneIcon.isHidden = false
                    cell.messageIcon.isHidden = true
                case .mobile:
                    cell.phoneIcon.isHidden = false
                    cell.messageIcon.isHidden = false
                }
            }
            return cell
            
        case 6:
            // Address
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactCellID, for: indexPath) as! PhoneNumberTableViewCell
            cell.titleLabel.numberOfLines = 0
            cell.titleLabel.text = "Address"
            cell.detailLabel.text = addressTextForUser(user)
            cell.phoneIcon.isHidden = true
            cell.messageIcon.isHidden = true
            return cell
            
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            return cell
        }
        
    }
    
}
