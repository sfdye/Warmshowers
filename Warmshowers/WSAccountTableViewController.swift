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
    
    var user: WSUser?
    var recipient: CDWSUser?
    
    // Delegates
    let store: WSStoreParticipantProtocol = WSStore.sharedStore
    let session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user != nil, "Account view loaded with nil user info.")
        guard user != nil else {
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
        
        // Get the users profile image if they have one.
        if user?.profileImage == nil && user?.profileImageURL != nil {
            api.contactEndPoint(.ImageResource, withPathParameters: user?.profileImageURL, andData: nil, thenNotify: self)
        }
        
        // Download the users feedback.
        api.contactEndPoint(.UserFeedback, withPathParameters: String(user!.uid) as NSString, andData: nil, thenNotify: self)
        
        configureDoneButton()
        configureActions()
        
        // configure the tableview
        tableView.rowHeight = UITableViewAutomaticDimension
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
        
//        // Common actions
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        actionAlert.addAction(cancelAction)
//        
//        if userIsLoggedIn() {
//            
//            // Options for the current user
//            
//            let logoutAction = UIAlertAction(title: "Logout", style: .Default) { (logoutAction) -> Void in
        
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
//            }
//            actionAlert.addAction(logoutAction)
//            
//        } else {
//            
//            // Options for any other user
//            
//            let messageAction = UIAlertAction(title: "Send Message", style: .Default) { (messageAction) -> Void in
//                // Present compose message view
//                self.performSegueWithIdentifier(ToSendNewMessageSegueID, sender: nil)
//            }
//            actionAlert.addAction(messageAction)
//            let provideFeedbackAction = UIAlertAction(title: "Provide Feedback", style: .Default) { (messageAction) -> Void in
//                // Present provide feeback view
//                self.performSegueWithIdentifier(ToProvideFeeedbackSegueID, sender: nil)
//            }
//            actionAlert.addAction(provideFeedbackAction)
//        }
    }

    // MARK: Utilities
    
    // Reloads the view
    func reload() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func memberForTextForUser(user: WSUser) -> String? {
        guard let membershipDuration = user.membershipDuration else { return "Duration of membership unknown." }
        return "Member for \(membershipDuration.asString)"
    }
    
    func activeAgoTextForUser(user: WSUser) -> String? {
        guard let lastLoggedInAgo = user.lastLoggedInAgo else { return "Last login time unknown." }
        return "Active \(lastLoggedInAgo.asString) ago"
    }
    
    func languagesSpokenTextForUser(user: WSUser) -> String? {
        guard let languagesspoken = user.languagesspoken else { return "Languages spoken: - " }
        return "Languages spoken: \(languagesspoken)"
    }
    
    func feedbackCellTextForUser(user: WSUser) -> String {
        guard let feedback = user.feedback else { return "Feedback" }
        return feedback.count > 0 ? "Feedback (\(feedback.count))" : "No feedback"
    }
    
    func hostingInfoTitleForInfoNumber(infoNumber: Int, fromUser user: WSUser) -> String? {
        
        return nil
    }
    
    func hostingInfoDetailForInfoNumber(infoNumber: Int, fromUser user: WSUser) -> String? {
        
        return nil
    }
    
    func offerTextForOfferNumber(offerNumber: Int, fromUser user: WSUser) -> String? {
//        var offer: String? {
//            get {
//                return offerLabel.text
//            }
//            set(newOffer) {
//                guard newOffer != nil else {
//                    self.offerLabel.text = nil
//                    return
//                }
//                self.offerLabel.text = "\u{2022} " + newOffer!
//            }
//        }
//        user.offers.offerAtIndex(indexPath.row - 5)
        return nil
    }
    
    func phoneNumberDescriptionForNumberNumber(number: Int, fromUser user: WSUser) -> String? {
        
        return nil
    }
    
    func phoneNumberForPhoneNumberNumber(number: Int, fromUser user: WSUser) -> String? {
        if let homephone = user.homephone where number == 0 {
            return homephone
        }
        if let mobilephone = user.mobilephone where number < 1 {
            return mobilephone
        }
        if let workphone = user.workphone where number < 2 {
            return workphone
        }
        return nil
        
//        let keys = ["homephone", "mobilephone", "workphone"]
//        
//        for key in keys {
//            let number = numberForKey(key, inJSON: json)
//            let type: WSPhoneNumberType
//            switch key {
//            case "homephone":
//                type = .Home
//            case "mobilephone":
//                type = .Mobile
//            case "workphone":
//                type = .Work
//            default:
//                continue
//            }
//        
//        return nil
    }
    
    func phoneNumberTypeForPhoneNumberNumber(number: Int, fromUser user: WSUser) -> WSPhoneNumberType? {
        
        return nil
    }
    
    func addressTextForUser(user: WSUser) -> String? {
        
        return nil
    }

}
