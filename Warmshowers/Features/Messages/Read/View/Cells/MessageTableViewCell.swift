//
//  MessageTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var authorImageView: UIImageView!
    
    var uid: Int = 0
    
    weak var delegate: MessageTableViewCellDelegate?
    
    private var labelTapGestureRecognizer: UITapGestureRecognizer!
    private var imageTapGestureRecognizer: UITapGestureRecognizer!
        
    override func awakeFromNib() {
        labelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.messageAuthorTapped(_:)))
        fromLabel.addGestureRecognizer(labelTapGestureRecognizer)
        imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.messageAuthorTapped(_:)))
        authorImageView.addGestureRecognizer(imageTapGestureRecognizer)
    }
    
    func messageAuthorTapped(_ sender: UITapGestureRecognizer) {
        delegate?.messageAuthorTapped(withUID: uid)
    }

}
