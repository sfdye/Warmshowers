//
//  FeedbackTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

class FeedbackTableViewController: UITableViewController, DataSource {

    var placeholderImage: UIImage? = UIImage(named: "ThumbnailPlaceholder")
    var feedback: [Recommendation]?
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(placeholderImage != nil, "Placeholder image not found while loading FeedbackTableViewController.")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 122
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadImagesForObjectsOnScreen()
    }
    
    // MARK: Utilities
    
    func startImageDownloadForIndexPath(_ indexPath: IndexPath) {
        guard let feedback = feedback , (indexPath as NSIndexPath).row < feedback.count else { return }
        let recommendation = feedback[(indexPath as NSIndexPath).row]
        guard recommendation.authorImage == nil else { return }
        if let url = recommendation.authorImageURL {
            api.contact(endPoint: .imageResource, withMethod: .get, andPathParameters: url, andData: nil, thenNotify: self, ignoreCache: false)
        } else if let uid = recommendation.author?.uid {
            // We first need to get the image URL from the authors profile.
            api.contact(endPoint: .user, withMethod: .get, andPathParameters: uid, andData: nil, thenNotify: self, ignoreCache: false)
        }
    }
    
    func loadImagesForObjectsOnScreen() {
        
        guard
            let feedback = feedback,
            let visiblePaths = tableView.indexPathsForVisibleRows
            , feedback.count > 0
            else {
                return
        }
        
        for indexPath in visiblePaths {
            startImageDownloadForIndexPath(indexPath)
        }
    }
    
    /** Sets the author image URL on the recommendation given the author UID. */
    func setAuthorImageURL(_ imageURL: String, forHostWithUID uid: Int) {
        guard let feedback = feedback else { return }
        for recommedation in feedback {
            if let authorUID = recommedation.author?.uid , authorUID == uid {
                recommedation.authorImageURL = imageURL
            }
        }
    }
    
    /** Sets the image for a host in the list with the given image URL. */
    func setImage(_ image: UIImage, forHostWithImageURL imageURL: String) {
        guard let feedback = feedback else { return }
        for (index, recommendation) in feedback.enumerated() {
            if recommendation.authorImageURL == imageURL {
                recommendation.authorImage = image 
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.cellForRow(at: indexPath)
                DispatchQueue.main.async(execute: { [weak cell] () -> Void in
                    (cell as? FeedbackTableViewCell)?.authorImage.image = recommendation.authorImage
                    })
            }
        }
    }
    
    func textForRecommendationDate(_ date: Date) -> String? {
        let template = "ddMMMyyyy"
        let locale = Locale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        return formatter.string(from: date)
    }
    
    func textColorForRecommedationRating(_ rating: RecommendationRating) -> UIColor {
        switch rating {
        case .positive:
            return WarmShowersColor.Positive
        case .negative:
            return WarmShowersColor.Negative
        case .neutral:
            return WarmShowersColor.Neutral
        }
    }
    
    func textForRecommendationType(_ type: RecommendationType) -> String? {
        switch type {
        case .forGuest:
            return NSLocalizedString("Host", comment: "Recommendation type for hosts")
        case .forHost:
            return NSLocalizedString("Guest", comment: "Recommendation type for guests")
        case .metTraveling:
            return NSLocalizedString("Met Traveling", comment: "Recommendation type of met travelling")
        case .other:
            return NSLocalizedString("Other", comment: "Recommendation type of other")
        }
    }

}
