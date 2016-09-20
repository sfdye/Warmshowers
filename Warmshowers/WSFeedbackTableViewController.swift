//
//  WSFeedbackTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSFeedbackTableViewController: UITableViewController {

    var placeholderImage: UIImage? = UIImage(named: "ThumbnailPlaceholder")
    var feedback: [WSRecommendation]?
    let formatter = DateFormatter()
    
    // Delegates
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(placeholderImage != nil, "Placeholder image not found while loading WSFeedbackTableViewController.")
        
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
            api.contactEndPoint(.ImageResource, withPathParameters: url as NSString, andData: nil, thenNotify: self)
        } else if let uid = recommendation.author?.uid {
            // We first need to get the image URL from the authors profile.
            api.contactEndPoint(.UserInfo, withPathParameters: String(uid) as NSString, andData: nil, thenNotify: self)
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
    
    func textColorForRecommedationRating(_ rating: WSRecommendationRating) -> UIColor {
        switch rating {
        case .Positive:
            return WSColor.Positive
        case .Negative:
            return WSColor.Negative
        case .Neutral:
            return WSColor.Neutral
        }
    }
    
    func textForRecommendationType(_ type: WSRecommendationType) -> String? {
        switch type {
        case .ForGuest:
            return "Host, "
        case .ForHost:
            return "Guest, "
        default:
            return type.rawValue + ", "
        }
    }

}
