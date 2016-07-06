//
//  WSCreateFeedbackTableViewController+UITextViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSCreateFeedbackTableViewController : UITextViewDelegate {
    
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
            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: false)
        }
        
        // Update the model
        feedback.body = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        feedback.body = textView.text
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == PlaceholderFeedback {
            textView.text = ""
            textView.textColor = UIColor.black()
        }
        removeAllPickerCells()
        return true
    }
}
