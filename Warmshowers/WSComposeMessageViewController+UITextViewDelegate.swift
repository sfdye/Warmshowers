//
//  WSComposeMessageViewController+UITextViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSComposeMessageViewController : UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        
        // Resize the table cell
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.max))
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0), atScrollPosition: .Bottom, animated: false)
        }
        
        // Update the model
        body = textView.text
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        body = textView.text
    }
    
}
