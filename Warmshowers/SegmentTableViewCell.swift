//
//  SegmentTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 28/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol SegmentTableViewCellActions {
    
    func didSelectAbout()
    func didSelectHosting()
    func didSelectContact()
    
}

class SegmentTableViewCell: UITableViewCell {
    
    
    // MARK: Instance Properties
    
    // Text and background colors for active and inactive states
    //
    let activeTextColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    let activeBackgroundColor = UIColor.whiteColor()
    let inactiveTextColor = UIColor.whiteColor()
    let inactiveBackgroundColor = UIColor(red: 104/255, green: 109/255, blue: 117/255, alpha: 1)
    
    // The three 'tab' buttons
    //
    @IBOutlet var aboutButton: UIButton!
    @IBOutlet var hostingButton: UIButton!
    @IBOutlet var contactButton: UIButton!
    
    // The controllers delegate (to respond when the buttons are pressed)
    //
    var delegate: SegmentTableViewCellActions?
    
    
    // MARK: Actions
    
    @IBAction func didSelectAbout() {
        selectTab(aboutButton)
        if delegate != nil {
            delegate!.didSelectAbout()
        }
    }
    
    @IBAction func didSelectHosting() {
        selectTab(hostingButton)
        if delegate != nil {
            delegate!.didSelectHosting()
        }
    }
    
    @IBAction func didSelectContact() {
        selectTab(contactButton)
        if delegate != nil {
            delegate!.didSelectContact()
        }
    }
    
    
    // MARK: Style setting methods
    
    // Sets a button's style to active (white background with blue text)
    //
    func configureButtonAsActive(button: UIButton) {
        button.setTitleColor(activeTextColor, forState: .Normal)
        button.backgroundColor = activeBackgroundColor
    }
    
    // Sets a button's style to inactive (grey background with white text)
    //
    func configureButtonAsInactive(button: UIButton) {
        button.setTitleColor(inactiveTextColor, forState: .Normal)
        button.backgroundColor = inactiveBackgroundColor
    }
    
    // Sets the style of all buttons to inactive
    //
    func configureAllButtonsAsInactive() {
        configureButtonAsInactive(aboutButton)
        configureButtonAsInactive(hostingButton)
        configureButtonAsInactive(contactButton)
    }
    
    // Sets the style of one button to active and the others as inactive
    //
    func selectTab(tab: UIButton) {
        configureAllButtonsAsInactive()
        configureButtonAsActive(tab)
    }
    
}
