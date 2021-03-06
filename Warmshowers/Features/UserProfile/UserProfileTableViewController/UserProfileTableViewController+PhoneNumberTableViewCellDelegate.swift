//
//  UserProfileTableViewController+PhoneNumberTableViewCellDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/02/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation
import MessageUI

extension UserProfileTableViewController: PhoneNumberTableViewCellDelegate {
    
    func didSelectPhoneIcon(in cell: PhoneNumberTableViewCell) {
        guard
            let number = phoneNumber(from: cell.detailLabel.text),
            let url = URL(string: "tel://" + number)
            else { return }
        if UIApplication.shared.canOpenURL(url) {
            let alert = UIAlertController(title: "Call \(number) now?", message: nil, preferredStyle: .actionSheet)
            let callAction = UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(url, options: [String : Any](), completionHandler: nil)
            })
            alert.addAction(callAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(cancelAction)
            DispatchQueue.main.async { [unowned self] in
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func didSelectMessageIcon(in cell: PhoneNumberTableViewCell) {
        guard let number = phoneNumber(from: cell.detailLabel.text) else { return }
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = [number]
            DispatchQueue.main.async { [unowned self] in
                self.present(composeVC, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Sorry, your device is not set up for SMS services", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            DispatchQueue.main.async { [unowned self] in
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /** Returns a sanitised phone number from the given string or nil. */
    fileprivate func phoneNumber(from string: String?) -> String? {
        guard let string = string else { return nil }
        let allowed = CharacterSet.decimalDigits
        let filtered = string.unicodeScalars.filter({ (character) -> Bool in
            return allowed.contains(character)
        }).map { (unicodeScalar) -> Character in
            return Character(unicodeScalar)
        }
        return String(filtered)
    }
    
}
