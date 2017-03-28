//
//  UserProfileTableViewController+MFMessageComposeViewControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/02/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation
import MessageUI

extension UserProfileTableViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult){
        switch result {            
        case .failed:
            let alert = UIAlertController(title: "Sorry, your message failed to send.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            DispatchQueue.main.async { [unowned self] in
                self.present(alert, animated: true, completion: nil)
            }
        case .cancelled, .sent:
            DispatchQueue.main.async { [unowned controller] in
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
