//
//  WSMapLabel.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 6/08/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSMapLabel: UILabel {
    
    let insets = UIEdgeInsets.init(top: 5, left: 7, bottom: 5, right: 7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 6
        clipsToBounds = true
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size = super.intrinsicContentSize()
        size.width  += self.insets.left + self.insets.right
        size.height += self.insets.top + self.insets.bottom
        return size
    }
    
}

