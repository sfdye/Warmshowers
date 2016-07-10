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
        return 6
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = user else { return 0 }
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 1
        case 4:
            var cells = user.hostingInfo.count
            if user.offers.count > 0 {
                cells += 1 + user.offers.count
            }
            return 0 //cells
        case 5:
            return user.phoneNumbers.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let user = user else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                // Photo
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
                if user.isAvailable {
                    cell.configureAsAvailable()
                } else {
                    cell.configureAsNotAvailable()
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
            if user.feedback.count > 0 {
                cell.textLabel?.text = String(format: "Feedback (%i)", arguments: [user.feedback.count])
            } else {
                cell.textLabel?.text = "Feedback"
            }
            return cell
            
        case 3:
            // About
            let cell = tableView.dequeueReusableCellWithIdentifier(AboutCellID, forIndexPath: indexPath) as! AboutTableViewCell
            cell.aboutLabel.text = user.comments
            return cell
            
        case 4:
            // Hosting info
            if indexPath.row < user.hostingInfo.count {
                // Display host info
                let cell = tableView.dequeueReusableCellWithIdentifier(HostingInfoCellID, forIndexPath: indexPath) as! HostingInfoTableViewCell
                cell.title = user.hostingInfo.titleValues[indexPath.row]
                cell.info = user.hostingInfo.infoValues[indexPath.row]
                return cell
            } else if indexPath.row == user.hostingInfo.count {
                // Display "This host may offer"
                let cell = tableView.dequeueReusableCellWithIdentifier(OfferHeadingCellID, forIndexPath: indexPath)
                return cell
            } else {
                // Display an offer
                let cell = tableView.dequeueReusableCellWithIdentifier(OfferCellID, forIndexPath: indexPath) as! HostOfferTableViewCell
                cell.offer = user.offers.offerAtIndex(indexPath.row - 5)
                return cell
            }
            
        case 5:
            // Contact details
            let phoneNumber = user.phoneNumbers.numbers[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(ContactCellID, forIndexPath: indexPath) as! PhoneNumberTableViewCell
            cell.titleLabel.text = phoneNumber.description
            cell.detailLabel.text = phoneNumber.number
            switch phoneNumber.type {
            case .Home, .Work:
                cell.phoneIcon.hidden = false
                cell.messageIcon.hidden = true
            case .Mobile:
                cell.phoneIcon.hidden = false
                cell.messageIcon.hidden = false
            }
            return cell
            
        default:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            return cell
        }
        
    }
    
}