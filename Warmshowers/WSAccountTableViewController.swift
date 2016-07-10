//
//  WSAccountTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 24/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

enum HostProfileTab {
    case About
    case Hosting
    case Contact
}

class WSAccountTableViewController: UITableViewController {
    
    let PHOTO_KEY = "profile_image_mobile_profile_photo_std"
    
    var userInfo: WSUser?
    
    var uid: Int!
    var info: AnyObject?
    var user: WSUserLocation?
    var feedback = [WSRecommendation]()
    var hostingInfo = WSHostingInfo()
    var offers = WSOffers()
    var phoneNumbers = WSPhoneNumbers()
    var photo: UIImage?
    var recipient: CDWSUser?
    
    var tab: HostProfileTab = .About
    
    var actionAlert = UIAlertController()
    
    // Delegates
    let store: WSStoreParticipantProtocol = WSStore.sharedStore
    let session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(userInfo != nil, "Account view loaded with nil user info.")
        guard userInfo != nil else {
            let alert = UIAlertController(title: "Sorry, an error occured.", message: nil, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (okAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        navigationItem.title = ""
        navigationItem.leftBarButtonItem?.tintColor = WSColor.LightGrey
        
        configureDoneButton()
        configureActions()
        
        // configure the tableview
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        if uid != nil {
            
//            // Get the users profile
//            WSRequest.getUserInfo(uid!, doWithUserInfo: { (info) -> Void in
//                self.updateWithUserInfo(info)
//            })
//            
//            // Get the users feedback
//            WSRequest.getUserFeedback(uid!, doWithUserFeedback: { (feedback) -> Void in
//                self.updateWithFeedback(feedback)
//            })
            
        } else {
            print("No uid")
        }
    }
    
    func updateWithUserInfo(info: AnyObject?) {
        
        guard let info = info  else {
            return
        }

        self.info = info
        self.user = WSUserLocation(json: info)
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
    func updateWithFeedback(json: AnyObject?) {
        
        guard let json = json else {
            return
        }
        
        var feedback = [WSRecommendation]()
        
        // Parse the data
        if let allRecommendations = json.valueForKey("recommendations") as? NSArray {
            for recommendationObject in allRecommendations {
                if let recommendationJSON = recommendationObject.valueForKey("recommendation") {
                    if let recommendation = WSRecommendation(json: recommendationJSON) {
                        feedback.append(recommendation)
                    }
                }
            }
        }
        
        // Set the feedback and update the table view
        self.feedback = feedback
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        
        // Update the feedback with user thumbnail urls
//        for feedback in self.feedback {
//            
//            guard let uid = feedback.author?.uid else {
//                return
//            }
            
//            WSRequest.getUserInfo(uid, doWithUserInfo: { (info) -> Void in
//                
//                guard let info = info else {
//                    return
//                }
//                
//                if let user = WSUserLocation(json: info) {
//                    feedback.authorImageURL = user.imageURL
//                }
//            })
//        }
    }
    
    // Downloads the users profile photo and updates the view
    func getProfileImage() {

//        guard let imageURL = info?.valueForKey(PHOTO_KEY) as? String else {
//            return
//        }
        
//        // Get the users profile image
//        WSRequest.getImageWithURL(imageURL, doWithImage: { (image) -> Void in
//            self.photo = image
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
//            })
//        })
    }
    
    func userIsLoggedIn() -> Bool {
        
        guard let uid = uid else {
            return false
        }
        
        return uid == session.uid
    }
    
    // Sets up a done button if one is needed
    //
    func configureDoneButton() {
        if navigationController?.viewControllers.count < 2 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(WSAccountTableViewController.doneButtonPressed))
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
//                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                let logoutManager = WSLogoutManager(
//                    success: {
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            WSProgressHUD.hide()
////                            appDelegate.logout() // DISABLED FOR NOW WHILE UPGRADING TO PROTOCOL ORIENTATED DESIGN
//                        })
//                    },
//                    failure: { (error) -> Void in
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            WSProgressHUD.hide()
////                            appDelegate.logout() // DISABLED FOR NOW WHILE UPGRADING TO PROTOCOL ORIENTATED DESIGN
//                        })
//                    }
//                )
//                WSProgressHUD.show(self.navigationController!.view, label: "Logging out ...")
//                logoutManager.logout()
            }
            actionAlert.addAction(logoutAction)
            
        } else {
            
            // Options for any other user
            
            let messageAction = UIAlertAction(title: "Send Message", style: .Default) { (messageAction) -> Void in
                // Present compose message view
                self.performSegueWithIdentifier(ToSendNewMessageSegueID, sender: nil)
            }
            actionAlert.addAction(messageAction)
            let provideFeedbackAction = UIAlertAction(title: "Provide Feedback", style: .Default) { (messageAction) -> Void in
                // Present provide feeback view
                self.performSegueWithIdentifier(ToProvideFeeedbackSegueID, sender: nil)
            }
            actionAlert.addAction(provideFeedbackAction)
        }
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
                var cells = phoneNumbers.count
                if user != nil {
                    cells += 1
                }
                return cells
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
                let cell = tableView.dequeueReusableCellWithIdentifier(ImageCellID, forIndexPath: indexPath) as! ProfileImageTableViewCell
                cell.nameLabel.text = self.info?["fullname"] as? String
                // TODO set the photo height to 35% of the screen height
                if let photo = photo {
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
                cell.configureAsCurrentlyAvailable(info)
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
                cell.configureAsMemberFor(info)
                return cell
            case 1:
                // Active ... ago
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountDetailCellID, forIndexPath: indexPath) as! AccountDetailTableViewCell
                cell.configureAsActiveAgo(info)
                return cell
            case 2:
                // Languages spoken: ...
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountDetailCellID, forIndexPath: indexPath) as! AccountDetailTableViewCell
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
                let cell = tableView.dequeueReusableCellWithIdentifier(FeedbackCountCellID, forIndexPath: indexPath)
                if feedback.count > 0 {
                    cell.textLabel?.text = String(format: "Feedback (%i)", arguments: [feedback.count])
                } else {
                    cell.textLabel?.text = "Feedback"
                }
                return cell
            case 1:
                // Info tabs
                let cell = tableView.dequeueReusableCellWithIdentifier(SegmentCellID, forIndexPath: indexPath) as! SegmentTableViewCell
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
                let cell = tableView.dequeueReusableCellWithIdentifier(AboutCellID, forIndexPath: indexPath) as! AboutTableViewCell
                if info != nil {
                    cell.aboutLabel.text = info!.valueForKey("comments") as? String
                } else {
                    cell.aboutLabel.text = nil
                }
                return cell
            case .Hosting:
                // Hosting tab
                if row < hostingInfo.count {
                    // Display host info
                    let cell = tableView.dequeueReusableCellWithIdentifier(HostingInfoCellID, forIndexPath: indexPath) as! HostingInfoTableViewCell
                    cell.title = hostingInfo.titleValues[row]
                    cell.info = hostingInfo.infoValues[row]
                    return cell
                } else if row == hostingInfo.count {
                    // Display "This host may offer"
                    let cell = tableView.dequeueReusableCellWithIdentifier(OfferHeadingCellID, forIndexPath: indexPath)
                    return cell
                } else {
                    // Display an offer
                    let cell = tableView.dequeueReusableCellWithIdentifier(OfferCellID, forIndexPath: indexPath) as! HostOfferTableViewCell
                    cell.offer = offers.offerAtIndex(row - 5)
                    return cell
                }
            case .Contact:
                // Contact tab
                var phoneRow = row
                if let user = user {
                    if row == 0 {
                        let cell = tableView.dequeueReusableCellWithIdentifier(ContactCellID, forIndexPath: indexPath) as! ContactTableViewCell
                        cell.setWithAddress(user.address)
                        return cell
                    }
                    phoneRow -= 1
                }
                let cell = tableView.dequeueReusableCellWithIdentifier(ContactCellID, forIndexPath: indexPath) as! ContactTableViewCell
                cell.setWithPhoneNumber(phoneNumbers.numbers[phoneRow])
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
        if cell?.reuseIdentifier == SegmentCellID {
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
        case ToFeedbackSegueID:
            return feedback.count > 0
        case ToSendNewMessageSegueID:
            return (info != nil && uid != nil && recipient != nil)
        case ToProvideFeeedbackSegueID:
            return info?.valueForKey("name") as? String != nil ? true : false
        default:
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ToFeedbackSegueID {
            let feedbackVC = segue.destinationViewController as! WSFeedbackTableViewController
            feedbackVC.feedback = feedback
        }
        if segue.identifier == ToSendNewMessageSegueID {
            let navVC = segue.destinationViewController as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! WSComposeMessageViewController
            if let info = info, let uid = uid {
                // Save the user to the store and pass the user object to the compose message view controller
                do {
                    try store.addParticipantWithJSON(info)
                    recipient = try store.participantWithID(uid)
                    composeMessageVC.initialiseAsNewMessageToUser([recipient!])
                } catch {
                    print("Failed to get user for compose message view")
                }
            }
        }
        if segue.identifier == ToProvideFeeedbackSegueID {
            let navVC = segue.destinationViewController as! UINavigationController
            let createFeedbackVC = navVC.viewControllers.first as! WSCreateFeedbackTableViewController
            createFeedbackVC.configureForSendingFeedbackForUserWithUserName(info?.valueForKey("name") as? String)
        }
    }

    
    // MARK: Utilities
    
    // Reloads the view
    func reload() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationItem.title = self.info?.valueForKey("name") as? String
            self.tableView.reloadData()
        })
    }

}
