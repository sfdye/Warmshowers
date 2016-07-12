//
//  WSFeedbackTableViewController+UITableViewCellDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSFeedbackTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return feedback != nil ? 1 : 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedback?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedbackCellID, forIndexPath: indexPath) as! FeedbackTableViewCell
        guard let feedback = feedback where indexPath.row < feedback.count else { return cell }
        
        let recommendation = feedback[indexPath.row]
        
        cell.authorImage.image = recommendation.authorImage ?? placeholderImage
        cell.authorNameLabel.text = recommendation.author?.fullname
        cell.dateLabel.text = textForRecommendationDate(recommendation.date)
        cell.ratingLabel.text = recommendation.rating.rawValue
        cell.ratingLabel.textColor = textColorForRecommedationRating(recommendation.rating)
        cell.forLabel.text = textForRecommendationType(recommendation.type)
        cell.bodyLabel.text = recommendation.body
    
        return cell
    }
    
}
