//
//  MessageThreadsErrorView.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import UIKit

class MessageThreadsErrorView: UIView {
    
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    weak var delegate: MessageThreadsErrorViewDelegate?
    
    @IBAction func updateButtonTapped(_ button: UIButton) {
        showLoadingState()
        delegate?.messageThreadsErrorViewDidSelectUpdate(self)
    }
    
    func showLoadingState() {
        DispatchQueue.main.async { [unowned self] in
            self.updateButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func reset() {
        DispatchQueue.main.async { [unowned self] in
            self.updateButton.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
    
}
