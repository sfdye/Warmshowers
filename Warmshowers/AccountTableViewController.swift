//
//  AccountTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 24/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

// #759DEB - background blue
// #304767

let IMAGE_CELL_ID = "Photo"
let AVAILIBLITY_CELL_ID = "Availible"
let ACCOUNT_DETAIL_CELL_ID = "AccountDetail"
let FEEDBACK_COUNT_CELL_ID = "FeedbackCount"
let SEGMENT_CELL_ID = "Segment"
let ABOUT_CELL_ID = "About"
let HOSTINGINFO_CELL_ID = "HostingInfo"
let OFFER_HEADING_CELL_ID = "OfferHeading"
let OFFER_CELL_ID = "Offer"
let PHONE_CELL_ID = "Phone"

let FEEDBACK_SEGUE_ID = "ToFeedback"
let SEND_NEW_MESSAGE_SEGUE_ID = "ToSendNewMessage"
let PROVIDE_FEEDBACK_SEGUE_ID = "ToProvideFeedback"

enum HostProfileTab {
    case About
    case Hosting
    case Contact
}

class AccountTableViewController: UITableViewController {
    
    let PHOTO_KEY = "profile_image_mobile_profile_photo_std"
    
    var uid: Int?
    var info: AnyObject?
    var feedback: AnyObject?
    var hostingInfo: WSHostingInfo = WSHostingInfo()
    var offers: WSOffers = WSOffers()
    var phoneNumbers: WSPhoneContacts = WSPhoneContacts()
    var photo: UIImage?
    var user: CDWSUser?
    
    var tab: HostProfileTab = .About
    
    var actionAlert = UIAlertController()
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    weak var appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = ""
        
        configureDoneButton()
        configureActions()
        
        if uid != nil {

            // Get the users profile
            WSRequest.getUserInfo(uid!, doWithUserInfo: { (info) -> Void in
                self.updateWithUserInfo(info)
            })
            
            // Get the users feedback
            WSRequest.getUserFeedback(uid!, doWithUserFeedback: { (feedback) -> Void in
                self.updateWithFeedback(feedback)
            })
            
        } else {
            print("No uid")
        }
        
        // configure the tableview
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    func updateWithUserInfo(info: AnyObject?) {
        
        guard let info = info  else {
            return
        }
        
        self.info = info
        self.offers.update(info)
        self.hostingInfo.update(info)
        self.phoneNumbers.update(info)
        
        // Get the users profile photo
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        dispatch_async(queue) { () -> Void in
            self.getProfileImage()
        }
        
        reload()
    }
    
    //
    func updateWithFeedback(feedback: AnyObject?) {
        
        guard let feedback = feedback else {
            return
        }
        self.feedback = feedback
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
    }
    
    // Downloads the users profile photo and updates the view
    func getProfileImage() {

        guard let imageURL = info?.valueForKey(PHOTO_KEY) as? String else {
            return
        }
        
        // Get the users profile image
        WSRequest.getImageWithURL(imageURL, doWithImage: { (image) -> Void in
            self.photo = image
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
        })
    }
    
    func userIsLoggedIn() -> Bool {
        
        guard let uid = uid,
            let defaults = self.appDelegate?.defaults
        else {
            return false
        }
        
        let currentUserUID = defaults.valueForKey(DEFAULTS_KEY_UID)?.integerValue
        if uid == currentUserUID {
            return true
        } else {
            return false
        }
    }
    
    // Sets up a done button if one is needed
    //
    func configureDoneButton() {
        if navigationController?.viewControllers.count < 2 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("doneButtonPressed"))
        }
    }
    
    // Configures the popover menu for when the action button is pressed
    //
    func configureActions() {
        
        // Common actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionAlert.addAction(cancelAction)
        
        if userIsLoggedIn() {
            
            // Options for the current user
            
            let logoutAction = UIAlertAction(title: "Logout", style: .Default) { (logoutAction) -> Void in
                // Logout and return the login screeen
                WSRequest.logout({ (success) -> Void in
                    if success {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.appDelegate?.logout()
                        })
                    }
                })
            }
            actionAlert.addAction(logoutAction)
            
        } else {
            
            // Options for any other user
            
            let messageAction = UIAlertAction(title: "Send Message", style: .Default) { (messageAction) -> Void in
                // Present compose message view
                self.performSegueWithIdentifier(SEND_NEW_MESSAGE_SEGUE_ID, sender: nil)
            }
            actionAlert.addAction(messageAction)
            let provideFeedbackAction = UIAlertAction(title: "Provide Feedback", style: .Default) { (messageAction) -> Void in
                // Present provide feeback view
                self.performSegueWithIdentifier(PROVIDE_FEEDBACK_SEGUE_ID, sender: nil)
            }
            actionAlert.addAction(provideFeedbackAction)
            
        }

    }
    
    // Returns the number of feedbacks for the user (or nil if feedback could not be retrieved from the server)
    func numberOfFeedbacks() -> Int? {
        
        guard let feedback = feedback else {
            return nil
        }
        
        guard let recommendations = feedback.valueForKey("recommendations") else {
            return nil
        }
        
        return recommendations.count
    }

    // MARK: - Tableview Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            switch tab {
            case .About:
                return 1
            case .Hosting:
                var cells = hostingInfo.count
                if offers.count > 0 {
                    cells += 1 + offers.count
                }
                return cells
            case .Contact:
                return phoneNumbers.count
            }
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                // Photo
                let cell = tableView.dequeueReusableCellWithIdentifier(IMAGE_CELL_ID, forIndexPath: indexPath) as! ProfileImageTableViewCell
                if let photo = photo {
                    cell.nameLabel.text = self.info?.valueForKey("fullname") as? String
                    cell.nameLabel.textColor = UIColor.whiteColor()
                    cell.profileImage.image = photo
                    cell.profileImage.contentMode = .ScaleAspectFill
                } else {
                    cell.nameLabel.text = self.info?.valueForKey("fullname") as? String
                    cell.nameLabel.textColor = UIColor.blackColor()
                }
                return cell
            case 1:
                // Availiblity
                let cell = tableView.dequeueReusableCellWithIdentifier(AVAILIBLITY_CELL_ID, forIndexPath: indexPath) as! AvailiblityTableViewCell
                cell.configureAsCurrentlyAvailible(info)
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
                let cell = tableView.dequeueReusableCellWithIdentifier(ACCOUNT_DETAIL_CELL_ID, forIndexPath: indexPath) as! AccountDetailTableViewCell
                cell.configureAsMemberFor(info)
                return cell
            case 1:
                // Active ... ago
                let cell = tableView.dequeueReusableCellWithIdentifier(ACCOUNT_DETAIL_CELL_ID, forIndexPath: indexPath) as! AccountDetailTableViewCell
                cell.configureAsActiveAgo(info)
                return cell
            case 2:
                // Languages spoken: ...
                let cell = tableView.dequeueReusableCellWithIdentifier(ACCOUNT_DETAIL_CELL_ID, forIndexPath: indexPath) as! AccountDetailTableViewCell
                cell.configureAsLanguageSpoken(info)
                return cell
            default:
                let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
                return cell
            }
        case 2:
            // Feedback and tab cells
            switch indexPath.row {
            case 0:
                // Feedback
                let cell = tableView.dequeueReusableCellWithIdentifier(FEEDBACK_CELL_ID, forIndexPath: indexPath)
                if let nof = self.numberOfFeedbacks() {
                    cell.textLabel?.text = String(format: "Feedback (%i)", arguments: [nof])
                } else {
                    cell.textLabel?.text = "Feedback"
                }
                return cell
            case 1:
                // Info tabs
                let cell = tableView.dequeueReusableCellWithIdentifier(SEGMENT_CELL_ID, forIndexPath: indexPath) as! SegmentTableViewCell
                cell.delegate = self
                return cell
            default:
                let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
                return cell
            }
        case 3:
            // Information tabs
            let row = indexPath.row
            switch tab {
            case .About:
                // About tab
                let cell = tableView.dequeueReusableCellWithIdentifier(ABOUT_CELL_ID, forIndexPath: indexPath) as! AboutTableViewCell
                if info != nil {
                    cell.aboutLabel.text = info!.valueForKey("comments") as? String
                } else {
                    cell.aboutLabel.text = nil
                }
                return cell
            case .Hosting:
                // Hosting tab
                if row < hostingInfo.count {
                    let cell = tableView.dequeueReusableCellWithIdentifier(HOSTINGINFO_CELL_ID, forIndexPath: indexPath) as! HostingInfoTableViewCell
                    cell.title = hostingInfo.titleValues[row]
                    cell.info = hostingInfo.infoValues[row]
                    return cell
                } else if row == hostingInfo.count {
                    let cell = tableView.dequeueReusableCellWithIdentifier(OFFER_HEADING_CELL_ID, forIndexPath: indexPath)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(OFFER_CELL_ID, forIndexPath: indexPath) as! HostOfferTableViewCell
                    cell.offer = offers.offerAtIndex(row - 5)
                    return cell
                }
            case .Contact:
                // Contact tab
                let cell = tableView.dequeueReusableCellWithIdentifier(PHONE_CELL_ID, forIndexPath: indexPath) as! PhoneTableViewCell
                cell.setWithPhoneNumber(phoneNumbers.numbers[row])
                return cell
                
            }
        default:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            return cell
            
        }
        
    }
    
    
    // MARK: Tableview Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.reuseIdentifier == SEGMENT_CELL_ID {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.min
        case 1:
            return CGFloat.init(15)
        case 1:
            return CGFloat.init(15)
        case 3:
            return CGFloat.init(20)
        default:
            return CGFloat.min
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 400
        case 1:
            return 44
        default:
            return 44
        }
    }

    // MARK: Navigation
    
    func doneButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        self.presentViewController(actionAlert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case FEEDBACK_SEGUE_ID:
            return feedback != nil
        case SEND_NEW_MESSAGE_SEGUE_ID:
            return info != nil
        case PROVIDE_FEEDBACK_SEGUE_ID:
            return info?.valueForKey("name") as? String != nil ? true : false
        default:
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue
        if segue.identifier == FEEDBACK_SEGUE_ID {
            let feedbackVC = segue.destinationViewController as! FeedbackTableViewController
            feedbackVC.parseFeedbackJSON(self.feedback)
        }
        if segue.identifier == SEND_NEW_MESSAGE_SEGUE_ID {
            let navVC = segue.destinationViewController as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! ComposeMessageTableViewController
            saveUserInfo(info!)
            composeMessageVC.initialiseAsNewMessageToUser(user!)
        }
        if segue.identifier == PROVIDE_FEEDBACK_SEGUE_ID {
            let navVC = segue.destinationViewController as! UINavigationController
            let createFeedbackVC = navVC.viewControllers.first as! CreateFeedbackTableViewController
            createFeedbackVC.userName = info?.valueForKey("name") as? String
            createFeedbackVC.feedback.recommendedUserUID = uid
        }
    }

    
    // MARK: Utilities
    
    // Saves user profile data to the store and reloads the view
    func saveUserInfo(info: AnyObject) {
        
        self.user = NSEntityDescription.insertNewObjectForEntityForName("CDWSUser", inManagedObjectContext: moc) as? CDWSUser
        
        user?.updateFromJSON(info)
        
        // save user to the store
        do {
            try moc.save()
        } catch {
            print("Could not save MOC.")
        }
    }
    
    // Reloads the view
    func reload() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationItem.title = self.info?.valueForKey("name") as? String
            self.tableView.reloadData()
        })
    }
    
}
