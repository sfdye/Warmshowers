//
//  WSHostListTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let SID_HostListToUserAccount = "HostListToUserAccount"

class WSHostListTableViewController: UITableViewController {
    
    var placeholderImage: UIImage? = UIImage(named: "ThumbnailPlaceholder")
    var hosts: [WSUserLocation]?
    var numberOfHosts: Int { return hosts?.count ?? 0 }
    
    // Delegates
    var alert: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 74
        
        guard let hosts = hosts , hosts.count > 0 else {
            self.navigationItem.title = "Hosts"
            // No users in the data source. Dismiss the view with an error message
            let alert = UIAlertController(title: "Sorry, an error occured.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (okAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        self.navigationItem.title = "\(hosts.count) Hosts"
    }
    
    // MARK: Utilities
    
    func startImageDownloadForIndexPath(_ indexPath: IndexPath) {
        
        guard let hosts = hosts , (indexPath as NSIndexPath).row < numberOfHosts else {
            return
        }
        
        let user = hosts[(indexPath as NSIndexPath).row]
        if let url = user.imageURL , user.image == nil {
            api.contactEndPoint(.ImageResource, withPathParameters: url, andData: nil, thenNotify: self)
        }
    }
    
    func loadImagesForObjectsOnScreen() {
        
        guard
            let visiblePaths = tableView.indexPathsForVisibleRows
            , hosts != nil && numberOfHosts > 0
            else {
                return
        }
        
        for indexPath in visiblePaths {
            startImageDownloadForIndexPath(indexPath)
        }
    }
    
    /** Sets the image for a host in the list with the given image URL. */
    func setImage(_ image: UIImage, forHostWithImageURL imageURL: String) {
        guard let hosts = hosts else { return }
        for (index, host) in hosts.enumerated() {
            if host.imageURL == imageURL {
                host.image = image 
                DispatchQueue.main.async(execute: { [weak self] () -> Void in
                    self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    })
            }
        }
    }
    
    /** Initiates a download of a users profile. */
    func showUserProfileForHostWithUID(_ uid: Int) {
        WSProgressHUD.show(navigationController!.view, label: nil)
        api.contactEndPoint(.UserInfo, withPathParameters: String(uid) as NSString, andData: nil, thenNotify: self)
    }  
    
}
