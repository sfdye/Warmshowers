//
//  ComposeMessageViewController+UITextViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension ComposeMessageViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        // Resize the table cell
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.scrollToRow(at: IndexPath(row: 2, section: 0), at: .bottom, animated: false)
        }
        
        // Update the model
        body = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        body = textView.text
    }
    
}
